function robot_callback(~, message)
    global robot_pos
    robot_pos = [message.Pose.Position.X message.Pose.Position.Y];
end
