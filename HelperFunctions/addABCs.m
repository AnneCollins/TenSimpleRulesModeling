function tb = addABCs(ax, offset, fontsize, abcString)

% tb = addABCs(ax, offset, fontsize, abcString)
%
% Add letters to axes 
% Inputs:
%   ax        - axes handles
%   offset    - 2x1 vector of x-offset and y-offset of letter relative to 
%               default location in normalized units (optional default no 
%               offset) 
%   fontsize  - (optional default 20) size of fonts!
%   abcString - (optional, default A through Z) if you want non-standard
%               lettering or numbering of axes or lower case 
%               e.g. abcString = 'abcd';
%
% Output
%   tb        -  vector of handles to textboxes containing ABCs

% Robert Wilson
% rcw2@princeton.edu
% 10-Nov-2011

if exist('abcString')~= 1
    abcString = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
end
if exist('fontsize') ~= 1
    fontsize = 20;
end


if exist('offset')
    for i = 1:length(ax)
        pos(i,:) = get(ax(i), 'position');
        
    end
    ABCpos = [pos(:,1)+offset(1) pos(:,2)+pos(:,4)+offset(2)];
else
    for i = 1:length(ax)
        pos(i,:) = get(ax(i), 'outerposition');
        
    end
    ABCpos = [pos(:,1) pos(:,2)+pos(:,4)];
end



for i = 1:length(ax)
    tb(i) = annotation('textbox');
    set(tb(i), 'fontsize', fontsize, 'fontweight', 'bold', ...
        'margin', 0, 'horizontalAlignment', 'center', ...
        'verticalAlignment', 'top', 'lineStyle', 'none')
    
    set(tb(i), 'fontunits', 'normalized')
    fs = get(tb(i), 'fontsize');
    set(tb(i), 'fontunits', 'points')
    
    set(tb(i), 'string', abcString(i))
    
    rec = [ABCpos(i,1)-fs/2 ABCpos(i,2)-fs fs fs];
    set(tb(i), 'position', rec)
end



