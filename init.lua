----------------------------------------------------
-- This will be run at very first after ESP start --
----------------------------------------------------

-- so, some wifi init
-- 
wifi.setmode(wifi.STATION);
wifi.sta.config("EcoHome","a1b2c3d4");

wifi.sta.connect();

-- get some IP from AP
--
tmr.alarm(1,100, 1, function() 

    if wifi.sta.getip()==nil then
    
        print(" Wait for IP --> "..wifi.sta.status()); 
    else 
   
         print("New IP address is "..wifi.sta.getip()); 
         tmr.stop(1);

         -- do some 
         print('load sleep.lua');
         dofile('sleep.lua');
    end
end );
