home_x=0
home_y=0
home_z=0
x=home_x
y=home_y
z=home_z
p=0
 
function checkSpace()
        for i=1,16 do
                if( turtle.getItemCount(i) == 0 ) then
                        return true;
                end
        end
        return (compact(true,true))>0;
end
 
function compact(order,early)
        countFree=0;
        if( order ) then
                for i=1,15 do
                        if( turtle.getItemCount(i) > 0 and turtle.getItemSpace(i) > 0 ) then
                                turtle.select(i);
                                j=i+1;
                                while( turtle.getItemSpace(i) > 0 and j <= 16 ) do
                                        if( turtle.compareTo(j) ) then
                                                turtle.select(j);
                                                turtle.transferTo(i);
                                                turtle.select(i);
                                                if( early and turtle.getItemCount(j) == 0 ) then
                                                        turtle.select(1);
                                                        return 1;
                                                end
                                        end
                                        j=j+1;
                                end
                        end
                        if( turtle.getItemCount(i) == 0 ) then countFree=countFree+1; end;
                end
        else
                for i=16,1,-1 do
                        if( turtle.getItemCount(i) > 0 and turtle.getItemSpace(i) > 0 ) then
                                turtle.select(i);
                                j=i-1; 
                                while( turtle.getItemSpace(i) > 0 and j >= 1 ) do
                                        if( turtle.compareTo( j ) ) then
                                                turtle.select(j);
                                                turtle.transferTo(i);
                                                turtle.select(i);
                                                if( early and turtle.getItemCount(j) == 0 ) then
                                                        turtle.select(1);
                                                        return 1;
                                                end
                                        end
                                        j=j-1
                                end
                        end
                        if( turtle.getItemCount(i) == 0 ) then countFree=countFree+1; end;
                end
        end
        turtle.select(1);
        return countFree;
end
 
function newMineArea( dimX, dimY, dimZ, zskip )
        modX=1; modY=1; modZ=1;
        if( dimX < 0 ) then modX = -1; end
        if( dimY < 0 ) then modY = -1; end
        if( dimZ < 0 ) then modZ = -1; end
        minX=0; maxX=dimX*modX-1;
        minY=0; maxY=dimY*modY-1;
        minZ=0; maxZ=dimZ*modZ-1;
        tx=0; ty=0; tz=zskip*modZ;
        if( tz == 0 and dimZ*modZ > 1 ) then tz = 1*modZ; goto( tx, ty, tz ); end
        zmax = tz-modZ;
        dir=0;
        if( dimZ*modZ >= dimX*modX and dimZ*modZ >= dimY*modY ) then
                axis=0;
        elseif( dimY*modY >= dimX*modX ) then
                axis=1;
        else
                axis=2;
        end
        while true do
                if( not checkSpace() ) then
                        goto( home_x, home_y, home_z ); south();
                        if( turtle.detect() ) then
                                for s=1,16 do
                                        turtle.select(s);
                                        if not turtle.drop() then
                                                break
                                        end
                                end
                        end
                        if not checkSpace() then
                                if( zmax > 0 ) then zmax = zmax+2; end
                                print( "NO ROOM IN INVENTORY AFTER " .. zmax .. " FULL LEVELS" );
                                north();
                                exit();
                        else
                                goto( tx, ty, tz );
                        end
                end
                if( modZ < 0 ) then
                        if( z*modZ+1 <= maxZ ) then turtle.digDown(); end
                        if( z*modZ-1 >= minZ ) then turtle.digUp(); end
                else
                        if( z-1 >= minZ ) then turtle.digDown(); end
                        if( z*modZ+1 <= maxZ ) then turtle.digUp(); end
                end
                if( dir%2 == 0 ) then
                        if( x % 2 == 0 ) then
                                ty=ty+modY;
                                if( ty*modY > maxY ) then
                                        ty=maxY*modY;
                                        tx=tx+modX;
                                end
                        else
                                ty=ty-modY;
                                if( ty*modY < minY ) then
                                        ty=minY*modY;
                                        tx=tx+modX;
                                end
                        end
                        if( tx*modX > maxX ) then
                                tx=maxX*modX;
                                dir=dir+1;
                                if( tz*modZ == maxZ-3 or tz*modZ == maxZ-2 ) then
                                        zmax = tz+modZ;
                                        tz=maxZ*modZ;
                                elseif( tz*modZ >= maxZ-1 ) then
                                        return;
                                else
                                        zmax = tz+modZ;
                                        tz=tz+modZ*3;
                                end
                        end
                else
                        if( x % 2 == 0 ) then
                                ty=ty-modY;
                                if( ty*modY < minY ) then
                                        ty=minY*modY;
                                        tx=tx-modX;
                                end
                        else
                                ty=ty+modY;
                                if( ty*modY > maxY ) then
                                        ty=maxY*modY;
                                        tx=tx-modX;
                                end
                        end
                        if( tx*modX < minX ) then
                                tx=minX*modX;
                                dir=dir+1;
                                if( tz*modZ == maxZ-3 or tz*modZ == maxZ-2 ) then
                                        zmax = tz+modZ;
                                        tz=maxZ*modZ;
                                elseif( tz*modZ >= maxZ-1 ) then
                                        return;
                                else
                                        zmax = tz+modZ;
                                        tz=tz+modZ*3;
                                end
                        end
                end
                goto( tx, ty, tz );
        end
end
 
function wallsUp( tdx, tdy )
        for n=0,3 do
                find(1); turtle.placeUp();
                if( x == tdx and y == tdy ) then
                        find(1); turtle.placeDown();
                end
                if( x == 0 ) then
                        west(); find(1); turtle.place();
                else
                        east(); find(1); turtle.place();
                end
                if( y == 0 ) then
                        south(); find(1); turtle.place();
                else
                        north(); find(1); turtle.place();
                end
                if( x == 0 and y == 0 ) then
                        goto( 1, 0, nil );
                elseif( x == 1 and y == 0 ) then
                        goto( 1, 1, nil );
                elseif( x == 0 and y == 1 ) then
                        goto( 0, 0, nil );
                elseif( x == 1 and y == 1 ) then
                        goto( 0, 1, nil );
                end
        end
end
 
function wallsDown( tdx, tdy )
        for n=0,3 do
                if( x == tdx and y == tdy ) then
                        find(1); turtle.placeUp();
                end
                if( x == 0 ) then
                        west(); find(1); turtle.place();
                else
                        east(); find(1); turtle.place();
                end
                if( y == 0 ) then
                        south(); find(1); turtle.place();
                else
                        north(); find(1); turtle.place();
                end
                if( x == 0 and y == 0 ) then
                        goto( 1, 0, nil );
                elseif( x == 1 and y == 0 ) then
                        goto( 1, 1, nil );
                elseif( x == 0 and y == 1 ) then
                        goto( 0, 0, nil );
                elseif( x == 1 and y == 1 ) then
                        goto( 0, 1, nil );
                end
        end
end
 
function staircaseUp()
        wallsUp();
        goto( nil, nil, z+1 ); wallsUp(0,0);
        goto( nil, nil, z+1 ); wallsUp(1,0);
        goto( nil, nil, z+1 ); wallsUp(1,1);
        goto( nil, nil, z+1 ); wallsUp(0,1);
        goto( 0, 0, nil ); north();
end
 
function staircaseDown()
        wallsDown();
        goto( nil, nil, z-1 ); wallsDown(0,0);
        goto( nil, nil, z-1 ); wallsDown(1,0);
        goto( nil, nil, z-1 ); wallsDown(1,1);
        goto( nil, nil, z-1 ); wallsDown(0,1);
        goto( 0, 0, nil ); north();
end
 
function tunnelOne( xdim, zdim )
        modX=1;
        xdim = tonumber(xdim) or 1
        zdim = tonumber(zdim) or 2
        if( xdim < 0 ) then modX = -1; end
        goto( 0, y+1, 0 );
        tx=0; tz=0;
        while true do
                if( tx*modX % 2 == 0 ) then
                        tz=tz+1;
                        if( tz >= zdim ) then
                                tz=zdim-1;
                                tx=tx+modX;
                        end
                else
                        tz=tz-1;
                        if( tz < 0 ) then
                                tz=0;
                                tx=tx+modX;
                        end
                end
 
                north(); find(1); turtle.place();
                if( x == 0 ) then
                        if( modX == 1 ) then
                                west(); find(1); turtle.place();
                        else
                                east(); find(1); turtle.place();
                        end
                end
                if( x == xdim-modX ) then
                        if( modX == 1 ) then
                                east(); find(1); turtle.place();
                        else
                                west(); find(1); turtle.place();
                        end
                end
                if( z == 0 ) then
                        find(1); turtle.placeDown();
                end
                if( z == zdim-1 ) then
                        find(1); turtle.placeUp();
                end
 
                if( tx*modX >= xdim*modX ) then
                        goto( 0, nil, 0 );
                        return;
                end
                goto( tx, nil, tz );
        end
end
 
function find(target)
        if( turtle.getItemCount( target ) > 1 ) then
                turtle.select(target);
                return 1;
        end
        for i=1,16 do
                if( i ~= target ) then
                        turtle.select(i);
                        if( turtle.compareTo( target ) ) then
                                turtle.transferTo( target );
                                turtle.select(target);
                                return 1;
                        end
                end
        end
        goto( home_x, home_y, nil );
        goto( nil, nil, home_z );
        north();
        print( "NO MATERIAL FOUND" );
        exit();
end
 
function checkFuel()
        if( turtle.getFuelLevel() > (math.abs(x)-home_x)+(math.abs(y)-home_y)+(math.abs(z)-home_z)+10 ) then
                return 1;
        end
        print( "INSUFFICIENT FUEL" );
        goto( home_x, home_y, home_z ); north();
        exit();
end
 
function goto(tx,ty,tz)
        if( tx == nil ) then
                tx = x;
        end
        if( ty == nil ) then
                ty = y;
        end
        if( tz == nil ) then
                tz = z;
        end
        if( tx ~= home_x or ty ~= home_y or tz ~= home_z ) then
                checkFuel();
        end
        while( z < tz ) do
                if( turtle.up() ) then
                        z=z+1;
                else
                        turtle.digUp();
                end
        end
        while( z > tz ) do
                if( turtle.down() ) then
                        z=z-1;
                else
                        turtle.digDown();
                end
        end
        while( y < ty ) do
                if( p == 2 and turtle.back() ) then
                        y=y+1;
                else
                        north();
                        if turtle.forward() then
                                y=y+1;
                        else
                                turtle.dig();
                        end
                end
        end
        while( y > ty ) do
                if( p == 0 and turtle.back() ) then
                        y=y-1;
                else
                        south();
                        if turtle.forward() then
                                y=y-1;
                        else
                                turtle.dig();
                        end
                end
        end
        while( x < tx ) do
                if( p == 3 and turtle.back() ) then
                        x=x+1;
                else
                        east();
                        if turtle.forward() then
                                x=x+1;
                        else
                                turtle.dig();
                        end
                end
        end
        while( x > tx ) do
                if( p == 1 and turtle.back() ) then
                        x=x-1;
                else
                        west();
                        if turtle.forward() then
                                x=x-1;
                        else
                                turtle.dig();
                        end
                end
        end
end
 
function north()
        if( p == 2 ) then
                turtle.turnLeft(); turtle.turnLeft();
        end
        if( p == 1 ) then
                turtle.turnLeft();
        end
        if( p == 3 ) then
                turtle.turnRight();
        end
        p=0;
end
 
function east()
        if( p == 0 ) then
                turtle.turnRight();
        end
        if( p == 2 ) then
                turtle.turnLeft();
        end
        if( p == 3 ) then
                turtle.turnLeft(); turtle.turnLeft();
        end
        p=1;
end
 
function west()
        if( p == 0 ) then
                turtle.turnLeft();
        end
        if( p == 1 ) then
                turtle.turnLeft(); turtle.turnLeft();
        end
        if( p == 2 ) then
                turtle.turnRight();
        end
        p=3;
end
 
function south()
        if( p == 0 ) then
                turtle.turnLeft(); turtle.turnLeft();
        end
        if( p == 1 ) then
                turtle.turnRight();
        end
        if( p == 3 ) then
                turtle.turnLeft();
        end
        p=2;
end
 
function httpDownload( url, path )
        local response = http.get( url );
        if response then
                local sResponse = response.readAll();
                response.close();
                local file = fs.open( path, "w" );
                file.write( sResponse );
                file.close();
                return 1;
        else
                print( "Error retrieving " .. url );
                return 0;
        end
end
 
function getopt( arg, options )
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end
 
function nextPoint( list, point )
        max_z = 0;
        for tx,rank in pairs(list) do
                for ty,col in pairs(rank) do
                        for tz,v in pairs(col) do
                                if( tz > max_z ) then
                                        max_z = tz;
                                end
                        end
                end
        end
        best=nil; dist=9999999999999999999999;
        for tz = point[3], max_z do
                for tx,rank in pairs(list) do
                        for ty,col in pairs(rank) do
                                if( col[ tz ] == 1 or col[tz] == -1 ) then
                                        d = dist3d( point, {tx,ty,tz} );
                                        if( best == nil or d < dist ) then
                                                best = {tx,ty,tz};
                                                dist = d;
                                        end
                                end
                        end
                end
                if( best ~= nil ) then
                        return best;
                end
        end
        return nil;
end
 
function dist3d( p1, p2 )
--      return math.sqrt( (p1[1]-p2[1])^2 + (p1[2]-p2[2])^2 + (p1[3]-p2[3])^2 );
-- Taxi geometry. THIS IS MINECRAFT.
        return math.abs( p1[1]-p2[1] ) + math.abs( p1[2]-p2[2] ) + math.abs( p1[3]-p2[3] );
end
 
function printModel( model, zskip, dryrun, verbose, match, material, final )
        if( zskip == nil )    then zskip = 0;       end
        if( dryrun == nil )   then dryrun = 0;      end
        if( verbose == nil )  then verbose = false; end
        if( match == nil )    then match = false;   end
        if( material == nil ) then material = 1;    end
        if( final == nil )    then final = true;    end
 
        point = nextPoint( model, { 0,0,zskip } );
        refpoint = point;
        action = model[point[1]][point[2]][point[3]];
        model[point[1]][point[2]][point[3]]=2;
--      if( not dryrun ) then goto( point[1], point[2], point[3] ); end
 
        last_yield_time = os.time()
 
        while( point ~= nil ) do
                if( os.time() > last_yield_time ) then sleep(0); last_yield_time = os.time(); end
                if( verbose ) then print( table.concat( point, "," ) .. "=" .. action ); end
                if( not dryrun ) then
                        goto( nil, nil, point[3]+1 );
                        goto( point[1], point[2], nil );
                        if( model[point[1]][point[2]][point[3]+1] == -1 ) then
                                model[point[1]][point[2]][point[3]+1] = 2;
                        end
                        if( action == 1 ) then
                                find(material);
                                if( match == 1 ) then
                                        while turtle.detectDown() and not turtle.compareDown() do
                                                turtle.digDown();
                                        end
                                end
                                turtle.placeDown();
                        else
                                turtle.digDown();
                        end
                end
                -- Find the next closest point from our reference.
                -- If it's distance>2, instead find the next closest point from here.
                point = nextPoint( model, refpoint )
                if( point == nil ) then break; end
                if( dist3d( point, refpoint ) > 2 ) then
                        point = nextPoint( model, point );
                        refpoint = point;
                end
                action = model[point[1]][point[2]][point[3]];
                model[point[1]][point[2]][point[3]]=2;
        end
 
        if( not dryrun and final ) then
                goto( homeX,homeY, nil );
                goto( nil, nil, z+1 );
                north();
        end
end
 
if( not fs.exists( "/m" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=xsCj9dzQ", "/m" ); end
if( not fs.exists( "/d" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=tA786Gnm", "/d" ); end
if( not fs.exists( "/f" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=wvdRkiet", "/f" ); end
if( not fs.exists( "/w" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=WDUq1Udj", "/w" ); end
if( not fs.exists( "/r" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=6smqCptJ", "/r" ); end
if( not fs.exists( "/t" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=iLSKuJj3", "/t" ); end
if( not fs.exists( "/rr" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=4BJA4dqc", "/rr" ); end     
if( not fs.exists( "/sc" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=ZHfa2YH9", "/sc" ); end
if( not fs.exists( "/dome" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=TzFZ3Sve", "/dome" ); end
if( not fs.exists( "/unload" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=YDYApMpe", "/unload" ); end
if( not fs.exists( "/recroom" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=QH3inEJm", "/recroom" ); end
if( not fs.exists( "/hypstruc" ) ) then httpDownload( "http://www.pastebin.com/raw.php?i=FajfpMQ5", "/hypstruc" ); end