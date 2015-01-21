-------------------------------------------
-- Get some data,                        --
-- send it to the Internet Server,       --
-- and do deep sleep for litle vhile     --
-------------------------------------------

-- get data ready
--
connection = false;
time = 0;
--if (file.open("time.dat", "r")) then
--
--    time = file.read();
--    print("read " ..time.. " from file");
--    
--    file.close();
--end;


-- create new connection
--
conn = net.createConnection(net.TCP, 0);

-- after retrieved data show web page header (first line of it)
--
conn:on( "receive", function(conn, payload) 

    s,e = string.find(payload, "\n");
    a = string.sub(payload, 0, e);
    print(a);
end );
  
-- once connected, request page and send parameters to the server
--
conn:on( "connection", function(conn, payload) 

    print("conected.");
    
    t = "time=" ..time.. "&mem=" ..node.heap();
    
    connection = true;

--    conn:send("GET /sett.php?time="..time
--            .." HTTP/1.0\r\n"
--            .."Host: my.bamo.cz\r\n"
--            .."Connection: close\r\n"
--            .."Accept: */*\r\n"
--            .."\r\n");

    conn:send("POST /onep:v1/stack/alias HTTP/1.1\r\n"
            .."Host: m2.exosite.com\r\n"
            .."X-Exosite-CIK: b367a49e96d95fc2c598b41570669fc9033f1865\r\n"
            .."Content-Type: application/x-www-form-urlencoded; charset=utf-8\r\n"
            .."Connection: close\r\n"
            .."Content-Length: " ..string.len(t).. "\r\n"
            .."\r\n"
            ..t
            );

    print("posted..");
end );
   
-- when disconnected sleep
--
conn:on("disconnection", function(conn, payload) 

    connection = false;

--    if (file.open("time.dat", "w+")) then
--    
--        file.write(tmr.now() / 1000);
--        file.close();
--    end;
    
    print("close conection...");
    
    -- after a sec do sleep
    --
 --    tmr.alarm(1,5000, 0, function() 
 --         
 --         print("sleep... ."); 
 --         node.dsleep(3000000); 
 --    end );
end );

-- do connect and send data
--
print("connect");
conn:connect(80,"m2.exosite.com");
--conn:connect(80,"my.bamo.cz");