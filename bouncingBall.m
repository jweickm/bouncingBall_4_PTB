© Jakob Weickmann, 2019
function bouncingBall(speed, radius, balls, random_angles, angles, precision)
% bouncingBall(speed, radius, balls, random_angles[0 or 1], angles[vector], precision)
% This function creates colourful bouncing balls. Press the up arrow to
% make them move faster and the down arrow to slow them down. With the '+'
% button they become larger and the '-' button makes them smaller. Press
% ESCAPE to end the simulation. 
% The input speed sets the speed at which they move (default: 7). Radius
% controls their size (default: 10), balls is the amount of balls
% (default:10). Random angles is set by default to 0, if it is set to 1,
% the angles at which the balls move are randomly generated - one for each
% ball. The last input argument is angles. This is a vector with one row,
% from which the angles are distributed to the balls. Can only be used when
% random angles is set to 0. Default: 45, 135, 225, 315.

PsychDefaultSetup(2);

% create default settings
if nargin < 1
    speed = 7;
end
if nargin < 2
    radius = 10;
end
if nargin < 3
    balls = 10;
end
if nargin < 4
    random_angles = 0;
end
if nargin < 5
    angles = [45 135 225 315];
end
if random_angles == 1
    % randomly generate angles (as many as balls)
    angles = randi(360,1,balls);
end
if nargin < 6 
    % precision is how many pixels inside of the figure the collision detection should stop
    precision = 10;
end

Screen('Preference', 'SkipSyncTests', 0);

diameter = radius*2;

% calculate the x and y increments for the four different angles according
% to the trigonometric functions. Careful! Matlab uses radians (2*pi rad=360��)
% x increment = cos(alpha) * speed
% y increment = sin(alpha) * speed

% this creates a matrix with 2 * the amount of input angles
angle_vector = zeros(2,length(angles));

% calculate the x and y increments for each angle
for i = 1:length(angles)
    angle_vector(:,i) = [cos(deg2rad(angles(i))) * speed, sin(deg2rad(angles(i))) * speed];
end

% creates the increment variable for each ball and attributes one of the
% possible angles to it
increment_xy = speed*ones(2,balls);

% increment vector for each ball in [,x and ,y] randomly generated from the
% angle_vector 
% if random_angles is active, attach one unique angle to each ball
if random_angles == 1
    for i = 1:balls
        increment_xy(:,i) = angle_vector(:,i);
    end
else
    for i = 1:balls
        increment_xy(:,i) = angle_vector(:,randi(length(angles)));
    end
end

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.

screenNumber = Screen('Screens'); 

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.

whichScreen = max(screenNumber);

% In general luminace values are defined between 0 and 255 

white = WhiteIndex(whichScreen);
black = BlackIndex(whichScreen);

% Open an onscreen window with darkwhite background
% rect1 = [000 000 800 500]; % for testing
bcolour = [250 250 250];

% rect always starts at [0 0]
[windowPtr, rect] = Screen('OpenWindow',whichScreen, bcolour);
width = rect(3);
height = rect(4);

% substract diameter so balls do not start in the wall
balls_xy = [randi(width-diameter,1,balls)+diameter/2;randi(height-diameter,1,balls)+diameter/2];

% define starting colour (exclude values that are too bright)
balls_colour = [randi(245,1,balls);randi(245,1,balls);randi(245,1,balls)];

%% Moveable shape in the middle
baseSquare = [0 0 400 400];
sx = rect(3)/2;
sy = rect(4)/2;
square = CenterRectOnPointd(baseSquare, sx, sy);

% Offset toggle. This determines if the offset between the mouse and centre
% of the square has been set. We use this so that we can move the position
% of the square around the screen without it "snapping" its centre to the
% position of the mouse
offsetSet = 0;

% Query the frame duration
ifi = Screen('GetFlipInterval', windowPtr);

% Sync us and get a time stamp
vbl = Screen('Flip', windowPtr);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(windowPtr);
Priority(topPriorityLevel);

% % Loop the animation until a key is pressed
% while ~KbCheck
% 
%     % Get the current position of the mouse
%     [mx, my, buttons] = GetMouse(windowPtr);
% 
%     % Find the central position of the square
%     [cx, cy] = RectCenter(square);
% 
%     % See if the mouse cursor is inside the square
%     inside = IsInRect(mx, my, square);
% 
%     % If the mouse cursor is inside the square and a mouse button is being
%     % pressed and the offset has not been set, set the offset and signal
%     % that it has been set
%     if inside == 1 && sum(buttons) > 0 && offsetSet == 0
%         dx = mx - cx;
%         dy = my - cy;
%         offsetSet = 1;
%     end
% 
%     % If we are clicking on the square allow its position to be modified by
%     % moving the mouse, correcting for the offset between the centre of the
%     % square and the mouse position
%     if inside == 1 && sum(buttons) > 0
%         sx = mx - dx;
%         sy = my - dy;
%     end
% 
%     % Center the rectangle on its new screen position
%     square = CenterRectOnPointd(baseSquare, sx, sy);
% 
%     % Draw the rect to the screen
%     Screen('FillRect', windowPtr, [100 100 100], square);
% 
%     % Draw a white dot where the mouse cursor is
%     Screen('DrawDots', windowPtr, [mx my], 10, white, [], 2);
% 
%     % Flip to the screen
%     vbl  = Screen('Flip', windowPtr, vbl + (waitframes - 0.5) * ifi);
% 
%     % Check to see if the mouse button has been released and if so reset
%     % the offset cue
%     if sum(buttons) <= 0
%         offsetSet = 0;
%     end
% 
% end

%% Balls
% Draw the dots
Screen('DrawDots', windowPtr, balls_xy, diameter, balls_colour, [], 3);
Screen('Flip', windowPtr);

% reset keyIsDown to zero
keyIsDown = 0;

% Start moving
while 1
    %%
    % Get the current position of the mouse
    [mx, my, buttons] = GetMouse(windowPtr);

    % Find the central position of the square
    [cx, cy] = RectCenter(square);

    % See if the mouse cursor is inside the square
    inside = IsInRect(mx, my, square);

    % If the mouse cursor is inside the square and a mouse button is being
    % pressed and the offset has not been set, set the offset and signal
    % that it has been set
    if inside == 1 && sum(buttons) > 0 && offsetSet == 0
        dx = mx - cx;
        dy = my - cy;
        offsetSet = 1;
    end

    % If we are clicking on the square allow its position to be modified by
    % moving the mouse, correcting for the offset between the centre of the
    % square and the mouse position
    if inside == 1 && sum(buttons) > 0
        sx = mx - dx;
        sy = my - dy;
    end

    % Center the rectangle on its new screen position
    square = CenterRectOnPointd(baseSquare, sx, sy);

%     % Draw the rect to the screen
%     Screen('FillRect', windowPtr, [100 100 100], square);
% 
%     % Draw a white dot where the mouse cursor is
%     Screen('DrawDots', windowPtr, [mx my], 10, white, [], 2);
% 
%     % Flip to the screen
%     vbl  = Screen('Flip', windowPtr, vbl + (waitframes - 0.5) * ifi);

    % Check to see if the mouse button has been released and if so reset
    % the offset cue
    if sum(buttons) <= 0
        offsetSet = 0;
    end
    %%
    [keyIsDown, secs, keyCode] = KbCheck(); % check for key presses
    if find(keyCode) == KbName('UpArrow')
        if abs(increment_xy(1)) < 70 % sanity check: upper border
            increment_xy = increment_xy * 1.1; % increase speed of the balls.
        end
    elseif find(keyCode) == KbName('DownArrow')
        if  abs(increment_xy(1)) > 0.05 % sanity check: lower border
            increment_xy = increment_xy * 0.9; % decrease ball speed
        end
    elseif find(keyCode) == KbName('return')
        increment_xy = -increment_xy;
        pause(0.15);
    elseif find(keyCode) == KbName('space')
        temporary = increment_xy;
        increment_xy = 0;
        KbStrokeWait();
        increment_xy = temporary;
    end
    if find(keyCode) == KbName('=+')
        if radius < 100 % sanity check
            radius = radius + 0.5; % increase size of the balls
        end
    elseif find(keyCode) == KbName('-_')
        if radius > 1 % sanity check
            radius = radius - 0.5; % decrease size of the balls
        end
    end
    
    % next, calculate the x and y increments on a per ball basis
    for i = 1:balls
        % x-increment
        balls_xy(1,i) = balls_xy(1,i) + increment_xy(1,i); 
    
        % y-increment
        balls_xy(2,i) = balls_xy(2,i) + increment_xy(2,i);
    
        % bounce against left wall
        if balls_xy(1,i) - radius <= rect(1)
            increment_xy(1,i) = abs(increment_xy(1,i));
            balls_colour(:,i) = randi(245,1,3);
        end

        % bounce against ceiling
        if balls_xy(2,i) - radius <= rect(2)
            increment_xy(2,i) = abs(increment_xy(2,i));
            balls_colour(:,i) = randi(245,1,3);
        end

        % bounce against right wall
        if balls_xy(1,i) + radius >= rect(3)
            increment_xy(1,i) = -abs(increment_xy(1,i));
            balls_colour(:,i) = randi(245,1,3);
        end
        
        % bounce against bottom
        if balls_xy(2,i) + radius >= rect(4)
            increment_xy(2,i) = -abs(increment_xy(2,i));
            balls_colour(:,i) = randi(245,1,3);
        end
        
       %% SHAPE IN THE MIDDLE
       % bounce against left wall of shape in the middle
        if balls_xy(1,i) + radius >= square(1) && balls_xy(1,i) + radius < square(1) + precision && balls_xy(1,i) + radius < square(3) && balls_xy(2,i) > square(2) && balls_xy(2,i) < square(4)
            increment_xy(1,i) = -abs(increment_xy(1,i));
            balls_colour(:,i) = randi(245,1,3);
        end

        % bounce against top wall of shape in the middle
        if balls_xy(2,i) + radius >= square(2) && balls_xy(2,i) + radius < square(2) + precision && balls_xy(2,i) + radius < square(4) && balls_xy(1,i) > square(1) && balls_xy(1,i) < square(3)
            increment_xy(2,i) = -abs(increment_xy(2,i));
            balls_colour(:,i) = randi(245,1,3);
        end

        % bounce against right wall of shape in the middle
        if balls_xy(1,i) - radius <= square(3) && balls_xy(1,i) - radius > square(3) - precision && balls_xy(1,i) - radius > square(1) && balls_xy(2,i) > square(2) && balls_xy(2,i) < square(4)
            increment_xy(1,i) = abs(increment_xy(1,i));
            balls_colour(:,i) = randi(245,1,3);
        end
        
        % bounce against bottom wall of shape in the middle
        if balls_xy(2,i) - radius <= square(4) && balls_xy(2,i) - radius > square(4) - precision && balls_xy(2,i) - radius > square(2) && balls_xy(1,i) > square(1) && balls_xy(1,i) < square(3)
            increment_xy(2,i) = abs(increment_xy(2,i));
            balls_colour(:,i) = randi(245,1,3);
        end
    end
    if find(keyCode) == KbName('Escape') % press escape to end
        break;
    end
    Screen('DrawDots', windowPtr, balls_xy, radius * 2, balls_colour, [], 3);
    Screen('FillRect', windowPtr, [100 100 100], square, 3);
    Screen('Flip', windowPtr);
end

% to close the window
KbStrokeWait;
Screen('CloseAll'); % or sca;
