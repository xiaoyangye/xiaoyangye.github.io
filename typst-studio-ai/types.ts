export interface File {
  id: string;
  name: string;
  language: 'typst' | 'markdown' | 'text';
  content: string;
  isUnsaved?: boolean;
}

export enum ActivityView {
  EXPLORER = 'EXPLORER',
  SEARCH = 'SEARCH',
  SETTINGS = 'SETTINGS'
}

export interface AiPreviewResponse {
  html: string;
  error?: string;
}