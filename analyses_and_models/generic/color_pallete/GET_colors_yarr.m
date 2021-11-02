I=imread('yarr.png');
% basel's first colorbox's top left point is (y,x) = [170,261]
% one colorbox's height = 29 pixels
% one colorbox's width = 67 pixels
% gap between one box to another box is = 6 pixels
% total 21 color box sets horizontally
% bottom left point of last colorbox is (y,x)= [910,261] 


start_point=[187,291];% 17 and 30 incremented in original topleft point

COLORS=struct;
break_flag_y=1;
count_colorset=1;
y_pos=start_point(1);
x_pos=start_point(2);
while break_flag_y==1

    break_flag_x=1;
    count_n=1;
    while break_flag_x==1
        
        pixel=I(y_pos,round(x_pos),:);
        if sum(pixel)==255*3
            break_flag_x=0;
            if count_n==1
                break_flag_y=0;
            end
        else
            COLORS(count_colorset).C(count_n,:)=squeeze(pixel)';
            count_n=count_n+1;
        end
        x_pos=x_pos+67;
    end
    x_pos=start_point(2);
    y_pos=y_pos+35;
    count_colorset=count_colorset+1;
end
save COLORS COLORS

