function clut_maker()
if ~ismac
    warning('not using macOS, saving to this functions directory instead');
    savepth = pwd;
else
    disp('saving clut to MRIcroGL.app');
    savepth = '/Applications/MRIcroGL/MRIcroGL.app/Contents/Resources/lut';
end
if ~exist(savepth, 'dir')
    warning('save path does not exist, saving to local folder where this script was run from.');
end
dlg = inputdlg({'Filename to save as (e.g. my_awesome_color): ','R G B (0..255): '},...
              'custom_color', [1 50; 1 20]);
n = strrep(dlg{1}, ' ', '_'); % replace spaces with underscores
rgb = strsplit(dlg{2}, ' ');
if size(rgb,2) < 3
    error('must input r g b separated by spaces');
end
r = str2num(rgb{1});
g = str2num(rgb{2});
b = str2num(rgb{3});
if r < 0 | r > 255
    error('red value must be between 0..255');
end
if b < 0 | b > 255
    error('blue value must be between 0..255');
end
if g < 0 | g > 255
    error('green value must be between 0..255');
end
fid = fopen(fullfile(savepth,[n '.clut']),'w');
fprintf(fid,...
    [   '[FLT]\n',...
        'min=0\n',...
        'max=0\n',...
        '[INT]\n',...
        'numnodes=3\n',...
        '[BYT]\n',...
        'nodeintensity0=1\n',...
        'nodeintensity1=128\n',...
        'nodeintensity2=255\n',...
        '[RGBA255]\n',...
        'nodergba0=%i|%i|%i|0\n',...
        'nodergba1=%i|%i|%i|64\n',...
        'nodergba2=%i|%i|%i|128'],...
        r,g,b,...
        r,g,b,...
        r,g,b);
fclose(fid);