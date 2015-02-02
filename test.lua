----------------------------------------------------
-- This will be run at very first after ESP start --
----------------------------------------------------

-- get time us and clear watchdog
--
last_time = time;
if (last_time == nil) then
     last_time = 0;
end
     
time = tmr.now();
tmr.wdclr();

-- set running time
--
if (run_time == nil) then
     run_time = 0;
else
     run_time = run_time + 10;
end

-- start every 10 sec
--
tmr.alarm(1,10000, 0, function() 
     
     dofile("test.lua"); 
end );

-- so, some wifi init
-- 
if (wifi.sta.getip() == nil) then
     wifi.setmode(wifi.STATION);
     wifi.sta.config("EcoHome","a1b2c3d4");

     wifi.sta.connect();
end

-- get some IP from AP
--
while (wifi.sta.getip() == nil) do
    
     print(" Wait for IP --> "..wifi.sta.status());
     tmr.delay(100000); 
end
   
print("IP address is "..wifi.sta.getip()); 

-------------------------------------------
-- Get some data,                        --
-- send it to the Internet Server,       --
-- and do deep sleep for litle vhile     --
-------------------------------------------

-- get data ready
--
connection = false;

-- create new connection
--
conn = net.createConnection(net.TCP, 0);

-- after retrieved data show web page header (first line of it)
--
conn:on( "receive", function(conn, payload) 

    time = tmr.now() - time;
    
    s,e = string.find(payload, "\n");
    a = string.sub(payload, 0, e -1);
    print(a);
    
end );
  
-- once connected, request page and send parameters to the server
--
conn:on( "connection", function(conn, payload) 

    print("conected.");
    vcc = string.format("%f", node.readvdd33());
    t = string.format("%f", last_time);
    sec = string.format("%d", run_time);
    
    t = "time=" ..t.. "&vcc=" ..vcc.. "&sec=" ..sec;
    
    connection = true;

    conn:send("POST /api:v1/stack/alias HTTP/1.1\r\n"
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
    
    print("close conection...\n");
    
end );

-- do connect and send data
--
print("connect");
conn:connect(80,"m2.exosite.com");
