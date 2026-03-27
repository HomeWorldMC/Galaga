function doplayer()
	doenemyhit()
	if player.alive then
		queue_spr(player.f,player.x,player.y,1,1,false,false)
	end
end

function doenemyhit()	
	if #nmerounds > 0 and player.alive then
		for r in all(nmerounds) do
			if doboxcollision(player.x,player.y,r.x-1,r.y-2,8) then				
				playerdeath()	
			end	
		end
	end
end

function resetplayer()
	if #nmesatt==0 then
		player.alive=true			
		player.t=1
		player.x=63
		player.y=112
		rounds={}
		nmerounds={}
		fire=0
	end
end

function playerdeath()
	
	if not invince and not disableplayer then
		printh("Player Died: #nmesatt="..#nmesatt..", #nmescap="..#nmescap..", player.lives="..player.lives..", nmealive="..tostr(nmealive)..", playfieldnmes="..playfieldnmes,"log.txt")
		sfx(2,2)  -- player explode sound
		player.alive=false
		player.lives-=1
		playerexplosion={x=player.x,y=player.y,t=1}

		if player.lives<0 then
			gameover=true
		end				
		player.t=2	
	end
end

function doboxcollision(sx,sy,tx,ty,size)
	if tx>sx and tx<=sx+size and ty>=sy and ty<=sy+size then
		return true
	end
  return false
end

function doboxoverlapcollision(ax,ay,bx,by,size)
	a={x1=ax,y1=ay,x2=ax+size,y2=ay+size}
	b={x1=bx,y1=by,x2=bx+size,y2=by+size}
	return not (
		a.x2 < b.x1 or
		a.x1 > b.x2 or
		a.y2 < b.y1 or
		a.y1 > b.y2
	)
end

function dorectoverlapcollision(ax,ay,bx,by,asizex,asizey,bsizex,bsizey)
	a={x1=ax, y1=ay, x2=ax+asizex, y2=ay+asizey}
	b={x1=bx, y1=by, x2=bx+bsizex, y2=by+bsizey}
	queue_rect(ax,ay,ax+asizex,ay+asizey,7)
	queue_rect(bx,by,bx+bsizex,by+bsizey,12)

	return not (
		a.x2 < b.x1 or
		a.x1 > b.x2 or
		a.y2 < b.y1 or
		a.y1 > b.y2
	)
end

function drawplayersprite(ang,x,y)
	local frs=capturedplayersprites

	local index=flr(ang*24)+1
	local fram={
		{capturedplayersprites[1],false,false},
		{capturedplayersprites[2],false,false},
		{capturedplayersprites[3],false,false},
		{capturedplayersprites[4],false,false},
		{capturedplayersprites[5],false,false},
		{capturedplayersprites[6],false,false},
		{capturedplayersprites[7],false,false},

		{capturedplayersprites[6],false,true},
		{capturedplayersprites[5],false,true},
		{capturedplayersprites[4],false,true},
		{capturedplayersprites[3],false,true},
		{capturedplayersprites[2],false,true},
		{capturedplayersprites[1],false,true},
		{capturedplayersprites[2],true,true},

		{capturedplayersprites[3],true,true},
		{capturedplayersprites[4],true,true},
		{capturedplayersprites[5],true,true},
		{capturedplayersprites[6],true,true},
		{capturedplayersprites[7],true,false},
		{capturedplayersprites[6],true,false},
		{capturedplayersprites[5],true,false},
		{capturedplayersprites[4],true,false},
		{capturedplayersprites[3],true,false},
		{capturedplayersprites[2],true,false}
	}
	queue_spr(fram[index][1],x,y,1,1,fram[index][2],fram[index][3])
end