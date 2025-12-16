import React from 'react';
import { Radio } from 'lucide-react';

interface StatusBarProps {
  line: number;
  col: number;
  isSaving: boolean;
}

const StatusBar: React.FC<StatusBarProps> = ({ line, col, isSaving }) => {
  return (
    <div className="h-6 bg-[#007acc] text-white flex items-center justify-between px-3 text-xs select-none z-30">
      <div className="flex items-center gap-4">
        <div className="flex items-center gap-1 font-bold">
            <Radio size={12} />
            <span>REMOTE</span>
        </div>
        <div>
            master*
        </div>
        {isSaving && <span>Saving...</span>}
      </div>

      <div className="flex items-center gap-4">
         <div className="hover:bg-white/10 px-1 rounded cursor-pointer">
            Ln {line}, Col {col}
         </div>
         <div className="hover:bg-white/10 px-1 rounded cursor-pointer">
            UTF-8
         </div>
         <div className="hover:bg-white/10 px-1 rounded cursor-pointer">
            Typst
         </div>
         <div className="hover:bg-white/10 px-1 rounded cursor-pointer">
            Prettier
         </div>
      </div>
    </div>
  );
};

export default StatusBar;
