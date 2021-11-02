function show_points(screenInfo,rew,payoff,reward_block)

theWindow = screenInfo.curWindow;
BG_color = screenInfo.bckgnd;
center = screenInfo.center;

cx = center(1);

colorFeedback = 255*[1 1 1];

R = rew.*payoff;


Screen(theWindow,'FillRect',BG_color);

delta = 35;

[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(rew(1)), cx-140, center(2)-25, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(rew(2)), cx-140, center(2)-25+delta, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(rew(3)), cx-140, center(2)-25+2*delta, colorFeedback);



[nx, ny, bbox] = DrawFormattedText(theWindow, 'queries', cx-100, center(2)-25, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, 'wrong choices', cx-100, center(2)-25+delta, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, 'correct choice', cx-100, center(2)-25+2*delta, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, 'TRIAL POINTS', cx-100, center(2)-25+3*delta, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, 'BLOCK POINTS', cx-100, center(2)-25+4*delta, colorFeedback);

[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(R(1)), cx+100, center(2)-25, [255,0,0]);
[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(R(2)), cx+100, center(2)-25+delta, [255,0,0]);
[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(R(3)), cx+100, center(2)-25+2*delta, [0,255,0]);
[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(sum(R)), cx+100, center(2)-25+3*delta, colorFeedback);
[nx, ny, bbox] = DrawFormattedText(theWindow, num2str(reward_block), cx+100, center(2)-25+4*delta, colorFeedback);

vbl = Screen('Flip',theWindow,0,1,0,0);