import { File } from './types';

export const INITIAL_FILES: File[] = [
  {
    id: '1',
    name: 'main.typ',
    language: 'typst',
    content: `= Introduction to Typst

This is a local, offline version of the studio.

== Formatting

You can use *bold* text, _italic_ text, and lists.

- Item 1
- Item 2

== Math Stub

$ E = m c^2 $

== Conclusion

Press Render to see the HTML conversion.`
  },
  {
    id: '2',
    name: 'styles.typ',
    language: 'typst',
    content: `// Local rendering does not support imports yet
#let corporate-theme(body) = {
  body
}`
  }
];

export const VS_THEME = {
  bg: '#1e1e1e',
  sidebarBg: '#252526',
  activityBarBg: '#333333',
  statusBarBg: '#007acc',
  borderColor: '#3e3e42',
  textColor: '#cccccc',
  accentColor: '#007acc',
};