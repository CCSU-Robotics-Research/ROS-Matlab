% This code is just a simple example of how to use ROS in MATLAB. It is a simple publisher-subscriber example. 
% The publisher node publishes a message on the chatter topic. The subscriber node subscribes to the chatter topic and receives the message. 
% The subscriber node then calls a function to find the maximum value from the three numbers in the message.
% I created two node where the subscriber node receives an array of 3 numbers from the publisher node and then use a custom function to find the maximum value.


% Thi block of  code check first if our globla ros master node is running, if so shut it downs and then 
% initialize again, if not then just initialize. Note that this is only necessary in this case because once we initialize the ros master node, it will stay running until we shut it down.
% if you want to run this code multiple times without shutting down the ros master node, you will get an error because the script in this file create two new nodes with the 
% each time with the same name, so you will need to change the name of the nodes in the script each time you click on the run button.


[~, result] = system('rosnode list');
if isempty(result)
    disp('ROS node is not running');
    rosinit
else
    disp('ROS node is already running');
    rosshutdown
    rosinit
end



% Create a ROS node with the name 'publisher_node_2'
node1 = ros.Node('publisher_node_2');

% Create another ROS node with the name 'subscriber_node'
node2 = ros.Node('subscriber_node');

% Create a publisher on the 'chatter' topic with the message type 'std_msgs/Float64MultiArray' on the 'publisher_node_2' node
pub = ros.Publisher(node1,'/chatter','std_msgs/Float64MultiArray');

% Create a subscriber on the 'chatter' topic with the message type 'std_msgs/Float64MultiArray' on the 'subscriber_node' node
sub = ros.Subscriber(node2,'/chatter','std_msgs/Float64MultiArray');

% Create an empty ROS message of the type 'std_msgs/Float64MultiArray'
msg = rosmessage('std_msgs/Float64MultiArray');

% Set the data field of the message to  an array of 3 numbers
msg.Data = [45, 40, 7.89];

% Publish the message on the 'chatter' topic
send(pub,msg);

% Wait for 1 second to allow the message to be received by the subscriber
pause(1);

% Get the latest message received by the subscriber
latest_msg = sub.LatestMessage;

% Check if the latest message is empty
if isempty(latest_msg)
% Display a message if no message is received
disp('No message received')
else
% Get the data from the latest message
data = latest_msg.Data;
% Call the function 'whoIsMax' with the three values
max_val = whoIsMax(data(1), data(2), data(3));
% Display the maximum value
disp(['Maximum value: ' num2str(max_val)]);
end
% Clear the publisher, subscriber, and nodes
clear('pub','sub','node1','node2')