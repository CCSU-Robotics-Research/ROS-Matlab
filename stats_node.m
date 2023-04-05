function stats_node()
    node = ros.Node('stats_node');
    pub = ros.Publisher(node, '/stats', 'std_msgs/Float64');
    sub = ros.Subscriber(node, '/data', 'std_msgs/Float64');
    
    t = timer('ExecutionMode', 'fixedRate', 'Period', 1.0, 'TimerFcn', {@publish_stats, sub, pub});
    start(t);
end

function publish_stats(~, ~, sub, pub)
    msg = receive(sub, 1.0);  % Receive message from subscriber with timeout of 1 second
    if ~isempty(msg)
        % Calculate statistics on received data
        data = msg.Data;
        mean_val = mean(data);
        max_val = max(data);
        min_val = min(data);
        
        % Publish statistics message
        stats_msg = rosmessage('std_msgs/Float64');
        stats_msg.Data = [mean_val, max_val, min_val];
        send(pub, stats_msg);
    end
end
