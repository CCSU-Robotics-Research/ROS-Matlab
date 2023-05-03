
[~, result] = system('rosnode list');
if isempty(result)
    disp('ROS node is not running');
    rosinit
else
    disp('ROS node is already running');
    rosshutdown
    rosinit
end


% Create a publisher for the robot's pose topic
pub = rospublisher('/robot/pose', 'geometry_msgs/Pose');

% Create a subscriber to the robot's pose topic
sub = rossubscriber('/robot/pose');

% Initialize the robot position
global robot_pos
robot_pos = [0 0];

% Plot the initial position
figure;
scatter(robot_pos(1), robot_pos(2), 'filled');
xlim([-5 5]);
ylim([-5 5]);

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
    robot_pos = pos(1:2);
    
    % Plot the robot position
    scatter(robot_pos(1), robot_pos(2), 'filled');
    
    % Wait for a short time
    pause(0.5);
end

% Shutdown ROS
rosshutdown
