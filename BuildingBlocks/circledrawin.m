% Asteroid Orbit Siulation
% Pawel Gucik
% Intro to Computor Simulation
% Charles S. Peskin
% 3/10/17

G           = 6.673e-11;        % Gravitational const in m^3/(kg*s)
M           = 1.9899e30;        % Mass of the center kg
m           = 1891e24;          % Mass of the planet kg
m_ast       = 2.9391e+21;       % Mass of asteroid(unused)
x           = 7.786e11;         % Initial x coordinate of planet
y           = 0;                % Initial y coordinate of planet
u           = 0;                % Initial x velocity of planet
v           = 13070;            % Initial y velocity of planet
xs          = 1.5*x;            % Size of axis
t_max       = 378432000;        % Jupiter 1 year(12 Earth years)
dt          = 86400*7;          % Time step 1 Earth week. We can multiple the by any number of 
                                % days to achieve a desired time step. i.e. *30 for 1 Earth month
clockmax    = ceil(t_max/dt);   % Number of iterations
ast_min     = 3.2912e+11;       % The min range of the asteroid belt(closest to the sun)
i           = 0;                % Where to draw asteroids in radians ( 0 = x-axis)
ast_count   = 0;                % Starting number of asteroids

% Initiate Drawing
set(gcf,'double','on')
plot(0,0,'r*');
hold on
axis equal
axis ([-xs,xs,-xs,xs])
axis manual
hold off
distance_mat = []; % to store distances

% Creat 5 asteroids at random distances
for j = 1:5
    distance     = 3.2912e+11 + 1.4960e+11.*rand(1);        % rand distance of asteroid
    distance_mat = [distance_mat distance];                 % store the distances, need for re-runs of the asts
    y_ast(j)     = distance*sin(i);                         % calculated y position
    x_ast(j)     = distance*cos(i);                         % calculated x position
    ast_count    = ast_count + 1;                           % counts number of asts 
    r_ast(j)     = sqrt((0-x_ast(j))^2 + (0-y_ast(j)^2));   % radius of each ast
end

% Calculate x and y velocity components
for ast = 1:ast_count
    s(ast) = sqrt(G*M/r_ast(ast));                  % Tangential velocity
    u_ast(ast) = -s(ast)*(y_ast(ast)/r_ast(ast));   % x-component of v
    v_ast(ast) = s(ast)*(x_ast(ast)/r_ast(ast));    % y-component of v
end

% Draw the asteroids in the initial positions
hold on
plot(x_ast,y_ast,'r.')
hold off
drawnow

% Create empty matrices to store variable of interest. Uncomment as needed
timegraph       = [];
velocity_mat1   = [];
velocity_mat5   = [];
velocity_mat1jup   = [];
velocity_mat5jup   = [];
radius_mat1     = [];
radius_mat5     = [];
radius_mat1jup  = [];
radius_mat5jup  = [];


% Start the orbit of Jupiter
for clock = 1:clockmax*3
    for ast = 1:ast_count
        %For each asteroid at each time step calculate:
            r_sunast(ast)   = sqrt((-x_ast(ast))^2 + (-y_ast(ast))^2);      % radius of ast from sun
            r_plast(ast)    = sqrt((x-x_ast(ast))^2 + (y-y_ast(ast))^2);    % radius of ast from planet
            u_ast(ast)      = u_ast(ast) - dt*(-(G*M*(0-x_ast(ast)))/...
                (r_sunast(ast)^3) - (G*m*(x-x_ast(ast)))/(r_plast(ast)^3)); % new x veloity
            v_ast(ast)      = v_ast(ast) - dt*(-(G*M*(0-y_ast(ast)))/...
                (r_sunast(ast)^3)- (G*m*(y-y_ast(ast)))/(r_plast(ast)^3));  % new y velocity
            x_ast(ast)      = x_ast(ast)+dt*u_ast(ast);                     % new x position
            y_ast(ast)      = y_ast(ast)+dt*v_ast(ast);                     % new y position
            
            % Store the values
            % valeus can be changed for whatever needs to be saved
            switch ast
                case 1
                    %velocity_mat1   = [velocity_mat1 u_ast(1)];
                    %radius_mat1     = [radius_mat1 r_sunast(1)];
                    velocity_mat1jup   = [velocity_mat1jup u_ast(1)];
                    radius_mat1jup  = [radius_mat1jup r_sunast(1)];
                    timegraph = [timegraph clock];
                case 5
                    %velocity_mat5   = [velocity_mat5 u_ast(5)];
                    %radius_mat5     = [radius_mat5 r_sunast(5)];
                    velocity_mat5jup   = [velocity_mat5jup u_ast(5)];
                    radius_mat5jup  = [radius_mat5jup r_sunast(5)];
                    timegraph = [timegraph clock];
            end
 
            % Draw the asteroid trajectory
            hold on
            plot(x_ast(ast),y_ast(ast),'g.');
            hold off
            drawnow
    end
    
    % Update radius, velocity, and positon values for Plant  
    r = sqrt(x^2 + y^2);
    u = u-(dt)*G*M*x/r^3;
    v = v-(dt)*G*M*y/r^3;
    x = x+dt*u;
    y = y+dt*v;   
    
    %Draw
    hold on
    plot(x,y,'b.');
    hold off
    drawnow
end