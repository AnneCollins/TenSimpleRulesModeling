function saveFigurePdf(figHandle, savename, flag, res)

% saveFigurePdf(figHandle, savename, flag, res)
%
% Saves figure as a pdf with the paper size clipped to the size of the
% figure
% figHandle - figure handle of figure to be saved
% savename - name of file to be saved
% flag - optional (default 0) flag = 0 => save as a regular pdf, 
%                             flag = 1 => save with -zbuffer and -r flags
% res - optional (only if flag = 1, default 300) resolution of picture
%
% NOTE : Setting flag = 1 can help deal with blurry rendering of pdfs on mac

% Robert Wilson
% 18-Mar-2010

if exist('flag') ~= 1
    flag = 0;
end

if exist('res') ~= 1
    res = 300;
end

set(figHandle, 'windowstyle', 'normal')
set(figHandle, 'paperpositionmode', 'auto')

pp = get(figHandle, 'paperposition');
wp = pp(3);
hp = pp(4);
set(figHandle, 'papersize', [wp hp])

if flag
    print(figHandle, '-dpdf', ['-r' num2str(res)], '-zbuffer', savename);
else
    print(figHandle, '-dpdf', savename);
end
