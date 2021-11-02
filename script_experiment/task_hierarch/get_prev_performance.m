function img = get_prev_performance(subject,extension,TASK_ID,points)

dire = 'prev_performance';
filename = [num2str(TASK_ID),'_',subject,'_',extension,'.mat'];

if exist(fullfile(dire,filename),'file')
    aux = load(fullfile(dire,filename));
    points = cat(1,aux.points(:),points);
end

save(fullfile(dire,filename),'points');

% make the figure
p = publish_plot(1,1);
hb = bar(points);
set(hb,'FaceColor',[0,0.7,0],'EdgeColor','w');
xlabel('block')
ylabel('points')
p.format('presentation','invert_colors');
set(gcf,'color','k');
saveas(gcf,'results.png','png');
close(gcf);

img = imread('results.png', 'png');

