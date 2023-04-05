% This code demonstrates a basic two-node communication using ROS (Robot Operating System).
% The first three lines of code create two nodes: publisher_node_2 and subscriber_node.
% The next two lines create a publisher and a subscriber objects for the two nodes respectively. The publisher sends a message to the subscriber on the topic /chatter.
% The rosmessage function is then used to create a message of type std_msgs/String with the message data "Hello, world!".
% The send function is used to send the message from the publisher node to the subscriber node.
% A pause of one second is added to wait for the message to be received by the subscriber.
% The sub.LatestMessage function is used to get the latest message received by the subscriber. If a message has been received, the code displays the message in the command window. Otherwise, it prints "No message received".
% Finally, the clear function is used to clear the publisher, subscriber, and node objects created in the code.



% Create a ROS node with the name 'publisher_node_2'
node1 = ros.Node('publisher_node_2');

% Create another ROS node with the name 'subscriber_node'
node2 = ros.Node('subscriber_node');

% Create a publisher on the 'chatter' topic with the message type 'std_msgs/String' on the 'publisher_node_2' node
pub = ros.Publisher(node1,'/chatter','std_msgs/String');

% Create a subscriber on the 'chatter' topic with the message type 'std_msgs/String' on the 'subscriber_node' node
sub = ros.Subscriber(node2,'/chatter','std_msgs/String');

% Create an empty ROS message of the type 'std_msgs/String'
msg = rosmessage('std_msgs/String');

% Set the data field of the message to 'Hello, world!'
msg.Data = 'Hello, world!';

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
% Display the data of the latest message if a message is received
disp(['Received: ' latest_msg.Data])
end

% Clear the publisher, subscriber, and nodes
clear('pub','sub','node1','node2')