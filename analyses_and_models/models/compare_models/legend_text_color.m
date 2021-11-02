function legend_text_color(hl,colors)

str = hl.String; 
for i=1:length(str)
    new_str{i} = ['\color[rgb]{',vec2str(colors(i,:)),'}', str{i}];
end
set(hl,'String',new_str,'FontAngle','italic');