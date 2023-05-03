% Initialize ROS
rosinit

% Load the Franka robot model
%load exampleHelperKINOVAGen3GripperROSGazebo.mat
[franka,config,env] = exampleHelperLoadPickAndPlaceRRT;

% Create a publisher for the robot's pose topic
pub = rospublisher('/robot/pose', 'geometry_msgs/Pose');

% Create a subscriber to the robot's pose topic
sub = rossubscriber('/robot/pose');

% Initialize the robot position
global robot_pos
robot_pos = [0 0 0];

% Plot the initial position
figure("Name","Pick and Place Using RRT",...
    "Units","normalized",...
    "OuterPosition",[0, 0, 1, 1],...
    "Visible","on");
show(franka,config,"Visuals","off","Collisions","on");
hold on
for i = 1:length(env)
    show(env{i});
end


% Set the callback function for the subscriber
sub.NewMessageFcn = @robot_callback;


% Loop to update the robot position and plot it on the graph
for i = 1:100
    % Generate a random position
    pos = [randn(1)*0.1 + robot_pos(1), randn(1)*0.1 + robot_pos(2), 0];
    
    % Create a Pose message and set its position
    pose = rosmessage(pub);
    pose.Position.X = pos(1);
    pose.Position.Y = pos(2);
    pose.Position.Z = pos(3);
    
    % Publish the message
    send(pub, pose);
    
    % Update the robot position
    robot_pos = pos;
    
    % Plot the robot position
    show(franka,robot_pos,"Visuals","off","Collisions","on");
    
    % Wait for a short time
    pause(1);
end

% Shutdown ROS
rosshutdown
