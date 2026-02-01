
// =============================================================
// GIST 本科毕业论文（设计）Typst 模板 (WASM Adaptation)
// =============================================================

#let size_2 = 22pt      // 二号
#let size_3 = 16pt      // 三号
#let size_x3 = 15pt      // 小三
#let size_4 = 14pt      // 四号
#let size_x4 = 12pt      // 小四
#let size_5 = 10.5pt    // 五号
#let size_x5 = 9pt       // 小五

// Fallback fonts for Web compatibility
#let font_cn = ("Noto Serif CJK SC", "Source Han Serif SC", "SimSun", "Songti SC", "STSong")
#let font_cn_bold = ("Noto Sans CJK SC", "Source Han Sans SC", "SimHei", "Heiti SC", "STHeiti")
#let font_en = ("Linux Libertine", "Times New Roman", "Times", "Georgia", "serif")

#let FONT_BODY = (..font_cn, ..font_en)
#let FONT_CN_BOLD = (..font_cn_bold, ..font_en)
#let FONT_EN = (..font_en,)

#let margin_setup = (top: 28mm, bottom: 22mm, left: 30mm, right: 20mm)
#set page(margin: margin_setup, header-ascent: 18mm, footer-descent: 14mm, footer: none)
#set text(font: FONT_BODY, size: size_x4, weight: 400)
#set par(justify: true, first-line-indent: 2em, leading: 0.55em)
#show regex("[a-zA-Z0-9.,;:!?'\"\-]+"): set text(font: FONT_EN)

#let start_on_odd(body) = {
  pagebreak(to: "odd", weak: true)
  body
}
#let new_side() = [#pagebreak()]

#let number_to_chinese(n) = {
  let digit_map = ("〇", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十")
  if n <= 10 { digit_map.at(n) } else if n < 20 { "十" + digit_map.at(n - 10) } else { str(n) }
}
#let heading_numbering(..args) = {
  let nums = args.pos()
  let l = nums.len()
  if l == 1 { number_to_chinese(nums.last()) + "、" } else if l == 2 {
    "（" + number_to_chinese(nums.last()) + "）"
  } else if l == 3 { str(nums.last()) + ". " } else if l == 4 { "（" + str(nums.last()) + "）" } else { none }
}
#set heading(numbering: heading_numbering)

#show heading.where(level: 1): it => {
  let titles = ("摘要", "目录", "参考文献", "致谢", "Abstract", "附录")
  let is_centered = titles.any(t => repr(it.body).contains(t))
  let content = it.body
  let body_text = repr(it.body)
  if body_text.contains("摘要") { content = [摘#h(4em)要] } else if body_text.contains("目录") {
    content = [目#h(2em)录]
  } else if body_text.contains("致谢") { content = [致#h(2em)谢] } else if body_text.contains("参考文献") {
    content = [参#h(1em)考#h(1em)文#h(1em)献]
  } else if body_text.contains("Abstract") { content = [Abstract] } // Fix: Abstract should be centered but not spaced like Chinese

  block(width: 100%)[
    #set text(font: FONT_CN_BOLD, size: size_3, weight: "bold")
    #set par(first-line-indent: 0em)
    #v(1em); #if is_centered { align(center)[#content] } else { content }; #v(1em)
  ]
}

#show heading.where(level: 2): it => block(width: 100%)[
  #set text(font: FONT_CN_BOLD, size: size_x3, weight: "bold"); #set par(first-line-indent: 0em)
  #v(0.5em); #if it.numbering != none { counter(heading).display(it.numbering) }; #it.body; #v(0.5em)
]

#show heading.where(level: 3): it => block(width: 100%)[
  #set text(font: FONT_CN_BOLD, size: size_x4, weight: "bold"); #set par(first-line-indent: 0em)
  #v(0.5em); #if it.numbering != none { counter(heading).display(it.numbering) }; #it.body; #v(0.5em)
]

#show heading.where(level: 4): it => block(width: 100%)[
  #set text(font: FONT_BODY, size: size_x4, weight: "regular"); #set par(first-line-indent: 0em)
  #v(0.5em); #if it.numbering != none { counter(heading).display(it.numbering) }; #it.body; #v(0.5em)
]

#let gist_cover(info) = {
  set page(header: none, footer: none, margin: (top: 25mm, bottom: 25mm, left: 25mm, right: 25mm))
  v(0.3cm)
  align(center)[#image("logo.png", width: 6.15in)]
  v(0.8cm) // Simplified path
  set text(font: FONT_CN_BOLD, size: 36pt, weight: "bold")
  align(center)[#info.thesis_type_cn]
  v(1.2cm)
  set text(font: FONT_BODY, size: size_3, weight: "regular")
  align(center)[
    #block(width: 100%)[
      #set text(font: FONT_CN_BOLD, weight: "bold", size: size_3)
      #grid(
        columns: (auto, 1fr),
        column-gutter: 0.5em,
        row-gutter: 1.2em,
        align: (left + top, center + top),
        [题目：],
        [
          #let parts = info.title_cn.split("——")
          #let main_title = parts.at(0)
          #box(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#main_title]
          #if parts.len() > 1 {
            let sub_title = "——" + parts.slice(1).join("——")
            v(0.8em)
            box(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#sub_title]
          }
        ],

        [#text(font: FONT_EN, size: size_x4)[Title:]],
        [
          #let title_en = info.title_en
          #if title_en.len() > 50 {
            let words = title_en.split(" ")
            let mid = calc.floor(words.len() / 2)
            box(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#text(font: FONT_EN, size: size_x4)[#(
              words.slice(0, mid).join(" ")
            )]]
            v(0.25em)
            box(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#text(font: FONT_EN, size: size_x4)[#(
              words.slice(mid).join(" ")
            )]]
          } else {
            box(width: 100%, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#text(
              font: FONT_EN,
              size: size_x4,
            )[#title_en]]
          }
        ],
      )
    ]
  ]
  v(1.5cm)
  align(center)[
    #block[
      #grid(
        columns: (90pt, 240pt),
        column-gutter: 1em,
        row-gutter: 1.2em,
        align: (right, center),
        [二级学院：],
        [#box(width: 240pt, stroke: (bottom: 0.5pt), inset: (bottom: 3pt))[#align(center)[#info.school_cn]]],

        [专业班级：],
        [#box(width: 240pt, stroke: (bottom: 0.5pt), inset: (bottom: 3pt))[#align(center)[#info.major_class_cn]]],

        [姓#h(2em)名：],
        [#box(width: 240pt, stroke: (bottom: 0.5pt), inset: (bottom: 3pt))[#align(center)[#info.name_cn]]],

        [学#h(2em)号：],
        [#box(width: 240pt, stroke: (bottom: 0.5pt), inset: (bottom: 3pt))[#align(center)[#info.student_id]]],

        [指导教师：],
        [#box(width: 240pt, stroke: (bottom: 0.5pt), inset: (bottom: 3pt))[#align(center)[#info.supervisor_cn]]],

        [日#h(2em)期：],
        [
          #let (y, m, d) = (h(2em), h(1.5em), h(1.5em))
          #if info.is_electronic {
            y = info.date_year
            m = info.date_month
            d = info.date_day
          }
          #box(width: 240pt)[
            #align(center)[
              #box(width: 50pt, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#y]
              #h(1fr)年#h(1fr)
              #box(width: 40pt, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#m]
              #h(1fr)月#h(1fr)
              #box(width: 40pt, stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#d]
              #h(1fr)日
            ]
          ]
        ],
      )
    ]
  ]
}

#let gist_declaration_page(info) = {
  // 设置物理页边距
  set page(
    header: none,
    footer: none,
    margin: (top: 1in, bottom: 0.87in, left: 1.25in, right: 0.79in),
    header-ascent: 0.59in,
    footer-descent: 0.69in,
  )
  let (year, month, day) = (h(2em), h(1.5em), h(1.5em))
  if info.is_electronic {
    year = info.date_year
    month = info.date_month
    day = info.date_day
  }

  v(0.6cm)
  align(center)[#text(font: FONT_CN_BOLD, size: size_3, weight: "bold")[广州理工学院本科毕业论文（设计）原创性声明]]
  v(1.0em)

  // Distributed alignment simplification for better WASM compatibility/font fallback
  align(center)[
    #block(width: 100%)[
      #set align(left)
      #set text(font: font_cn, size: 12pt)
      #set par(leading: 1.0em, first-line-indent: 2em, justify: true)

      本人郑重声明：所呈交的毕业论文（设计），是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文不包含任何其他个人或集体已经发表或撰写过的作品成果。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本人承诺，所提交的毕业论文（设计）中的所有内容均真实、可信。本人完全意识到本声明的法律结果由本人承担。
    ]
  ]
  v(3em)

  align(center)[
    #block(width: 100%)[
      #grid(
        columns: (1fr, 1fr),
        align(left)[#h(2em)作者签名：], align(left)[#h(2em)日期：#(year) 年 #(month) 月 #(day) 日],
      )
    ]
  ]

  v(144pt)
  align(center)[#text(font: FONT_CN_BOLD, size: size_3, weight: "bold")[广州理工学院本科毕业论文（设计）使用授权声明]]
  v(1.0em)

  align(center)[
    #block(width: 100%)[
      #set align(left)
      #set text(font: font_cn, size: 12pt)
      #set par(leading: 1.0em, first-line-indent: 2em, justify: true)

      本人完全了解学校有关保留、使用毕业论文（设计）的规定，同意学校保留并向国家有关部门或机构送交毕业论文（设计）的复印件和电子版，允许毕业论文（设计）被查阅和借阅。学校可以将本毕业论文（设计）的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或扫描等复制手段保存和汇编毕业论文（设计）。
    ]
  ]
  v(3em)

  align(center)[
    #block(width: 100%)[
      #grid(
        columns: (1fr, 1fr),
        row-gutter: 1.5em,
        align(left)[#h(2em)作者签名：], align(left)[#h(2em)指导教师签名：],
        align(left)[#h(2em)日期：#(year) 年 #(month) 月 #(day) 日],
        align(left)[#h(2em)日期：#(year) 年 #(month) 月 #(day) 日],
      )
    ]
  ]
}

#let zh_abstract(info, keywords, body) = start_on_odd[
  #set text(font: FONT_CN_BOLD, size: size_2, weight: "bold")
  #v(1em); #align(center)[#info.title_cn]; #v(1em)
  #heading(level: 1, numbering: none, outlined: false)[摘要]
  #set text(font: FONT_BODY, size: size_x4, weight: "regular")
  #set par(first-line-indent: 2em, justify: true, leading: 0.25em)
  #body
  #v(1em); #par(first-line-indent: 2em)[#text(font: FONT_CN_BOLD, weight: "bold")[关键词：]#text(
      font: FONT_BODY,
      weight: "regular",
    )[#keywords]]
]

#let en_abstract(info, author, keywords, body) = start_on_odd[
  #set text(font: FONT_EN, size: size_2, weight: "bold")
  #v(1em); #align(center)[#info.title_en]; #v(1em)
  #set text(font: FONT_EN, size: size_x4, weight: "bold")
  #align(center)[#author]; #align(center)[#info.unit_en]; #v(1em)
  #heading(level: 1, numbering: none, outlined: false)[Abstract]
  #set text(font: FONT_EN, size: size_x4, weight: "regular")
  #set par(first-line-indent: 2em, justify: true, leading: 0.25em)
  #body
  #v(1em); #par(first-line-indent: 2em)[#text(font: FONT_EN, weight: "bold")[Key words: ]#text(
      font: FONT_EN,
      weight: "regular",
    )[#keywords]]
]

#let gist_toc() = start_on_odd[
  #heading(level: 1, numbering: none, outlined: false)[目录]
  #show outline.entry.where(level: 1): it => {
    v(0.2em)
    set text(font: FONT_CN_BOLD, size: size_x4, weight: "bold")
    it
  }
  #set text(font: FONT_BODY, size: size_x4, weight: 400); #set par(leading: 0.25em)
  #outline(depth: 3, title: none, indent: 0em) // depth 3 is enough
]

#let gist_figure(img, caption, note: none) = [
  #v(1em); #align(center)[#img]; #v(0.3em); #set text(font: FONT_BODY, size: size_5, weight: "regular"); #align(
    center,
  )[图#caption]
  #if note != none {
    v(0.1em)
    align(center)[#text(size: size_x5)[注：#note]]
  }; #v(1em)
]

#let gist_table(caption, table_body, note: none) = [
  #v(1em); #set text(font: FONT_CN_BOLD, size: size_5, weight: "bold"); #align(center)[表#caption]; #v(0.3em)
  #set text(font: FONT_BODY, size: size_5); #table_body
  #if note != none {
    v(0.1em)
    align(left)[#text(size: size_x5)[注：#note]]
  }; #v(1em)
]

#let gist_equation(eq, num) = [
  #v(1em); #set text(font: FONT_EN, size: size_x4)
  #align(center)[#grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    align: (center, right),
    [#eq], [(#num)],
  )]; #v(1em)
]
