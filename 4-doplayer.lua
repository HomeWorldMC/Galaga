function doplayer()
	local pf={1,3,4,5,6,7,0}
	local f
	
	
	--doenemyhit()
	
	if not player.alive and not gameover then
		if not player.animlock then
			player.t+=0.1
			if player.t>7.9 then
				player.animlock=true
			end		
			
			f=pf[flr(player.t)]		
		end
	elseif player.alive then
		f=1	
	end
	queue_spr(f,player.x,player.y)
	--spr(f,player.x,player.y)
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
	
	if not invince then
		printh("Player Died: #nmesatt="..#nmesatt..", #nmescap="..#nmescap..", player.lives="..player.lives..", nmealive="..tostr(nmealive)..", playfieldnmes="..playfieldnmes,"log.txt")
		sfx(2,2)  -- player explode sound
		player.alive=false
		player.lives-=1
		add(explosions,{x=player.x,y=player.y,t=1})

		if player.lives<0 then
			--gamephase=0
			gameover=true
		--else 		
			--lastgamephase=gamephase
		end				
		player.animlock=false
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