function doplayer()
	
	if #nmerounds > 0 and player.alive then
		for r in all(nmerounds) do
			if player.p>1 and not invince then
				if not disableplayer then
					if doboxcollision(player.x+3,player.y,r.x-1,r.y-2,8) then
						playerexplosion={x=player.x+3,y=player.y,t=1}
						sfx(2,2)  -- player explode sound
						player.p=1
						del(nmerounds,r)
					elseif doboxcollision(player.x-4,player.y,r.x-1,r.y-2,8) then
						playerexplosion={x=player.x-4,y=player.y,t=1}
						sfx(2,2)  -- player explode sound
						player.p=1
						del(nmerounds,r)
					end
				end
			else
				if doboxcollision(player.x,player.y,r.x-1,r.y-2,8) and not disableplayer then				
					playerdeath()	
				end	
			end
		end
	end

	if player.alive then
		if player.p>1 then
			queue_spr(player.f,player.x+3,player.y,1,1,player.flipx,player.flipy)
			queue_spr(player.f,player.x-4,player.y,1,1,player.flipx,player.flipy)
		else
			queue_spr(player.f,player.x,player.y,1,1,player.flipx,player.flipy)
		end
		
	end
end

function playerdeath()
	if not invince then
		--printh("Player Died: #nmesatt="..#nmesatt..", #nmescap="..#nmescap..", player.lives="..player.lives..", nmealive="..tostr(nmealive)..", playfieldnmes="..playfieldnmes,"log.txt")
		
		player.alive=false
		player.lives-=1
		playerremains=1

		playerexplosion={x=player.x,y=player.y,t=1}
		sfx(2,2)  -- player explode sound
		
		if player.lives<0 then
			gameover=true
		end				
		player.t=2	
	end
end

function playercapture()
	--printh("Player Captures: #nmesatt="..#nmesatt..", #nmescap="..#nmescap..", player.lives="..player.lives..", nmealive="..tostr(nmealive)..", playfieldnmes="..playfieldnmes,"log.txt")
	
	player.alive=false
	player.lives-=1
	
	if player.lives<0 then
		gameover=true
	end				
	player.t=2	
	player.f=16
end

function doboxcollision(sx,sy,tx,ty,size)
	if tx>sx and tx<=sx+size and ty>=sy and ty<=sy+size then
		return true
	end
  return false
end

--function doboxoverlapcollision(ax,ay,bx,by,size)
--	a={x1=ax,y1=ay,x2=ax+size,y2=ay+size}
--	b={x1=bx,y1=by,x2=bx+size,y2=by+size}
--	return not (
--		a.x2 < b.x1 or
--		a.x1 > b.x2 or
--		a.y2 < b.y1 or
--		a.y1 > b.y2
--	)
--end

function dorectoverlapcollision(ax,ay,bx,by,asizex,asizey,bsizex,bsizey)
	a={x1=ax, y1=ay, x2=ax+asizex, y2=ay+asizey}
	b={x1=bx, y1=by, x2=bx+bsizex, y2=by+bsizey}

	return not (
		a.x2 < b.x1 or
		a.x1 > b.x2 or
		a.y2 < b.y1 or
		a.y1 > b.y2
	)
end

function drawplayersprite(ang,set)
	local playersprites={{16,17,18,19,20,21,22},{23,24,25,26,27,28,29}}
	
	local index=flr(ang*24)+1
	local fram={
		{playersprites[set][1],false,false},
		{playersprites[set][2],false,false},
		{playersprites[set][3],false,false},
		{playersprites[set][4],false,false},
		{playersprites[set][5],false,false},
		{playersprites[set][6],false,false},
		{playersprites[set][7],false,false},

		{playersprites[set][6],false,true},
		{playersprites[set][5],false,true},
		{playersprites[set][4],false,true},
		{playersprites[set][3],false,true},
		{playersprites[set][2],false,true},
		{playersprites[set][1],false,true},
		{playersprites[set][2],true,true},

		{playersprites[set][3],true,true},
		{playersprites[set][4],true,true},
		{playersprites[set][5],true,true},
		{playersprites[set][6],true,true},
		{playersprites[set][7],true,false},
		{playersprites[set][6],true,false},
		{playersprites[set][5],true,false},
		{playersprites[set][4],true,false},
		{playersprites[set][3],true,false},
		{playersprites[set][2],true,false}
	}
	return fram[index]
end