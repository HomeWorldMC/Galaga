function doenemy()
	if (playfield[1][10].x>fieldboundmax or playfield[1][1].x<fieldboundmin) then
		nmexmovespd=nmexmovespd*-1
	end	

	beginruntimer-=0.15
	
	nmecount=0	
	--queue_prt("doenemy", 5,100,7)
	--queue_prt("stagetimer="..tostr(stagetimer),5,110,7)
	-- For each slot, do movement.
	-- if the slot is not empty, get current alive nme count for random number determining attack run
	-- if attack run true, set attack position, add nme to nmeatt collection, and check if nme fires during run
	for r=1,#playfield do -- move enemy and roll deice for attack run
		for c=1,#playfield[r] do
			playfield[r][c].x+=nmexmovespd
			
			if not playfield[r][c].canwrite and playfield[r][c].nme.mode==0 then	
				nmecount+=1
				playfield[r][c].nme.x=playfield[r][c].x

				-- check to see if nme does attack run
				if beginruntimer<0 and flr(rnd(nmecount*5)+1)==1 and #nmesatt<3 and playfield[r][c].nme.mode==0 and player.alive and gamephase==3 then
					beginruntimer=4
					playfield[r][c].nme.mode=1
					playfield[r][c].nme.ax=playfield[r][c].nme.x
					playfield[r][c].nme.ay=playfield[r][c].nme.y
					playfield[r][c].nme.ph=rnd(1)

					if playfield[r][c].nme.typ==3 and #nmescap==0 and flr(rnd(2))==0 and not triedcapturethisstage then
						add(nmescap,playfield[r][c].nme)
						--triedcapturethisstage=true					
					else
						add(nmesatt,playfield[r][c].nme)
						doenemyfireroll(playfield[r][c].nme,true,0,70)
					end

					playfield[r][c].canwrite=true
					playfield[r][c].holdslot=false
					playfieldnmes-=1						
					sfx(6,3) -- nme attack run sound
				end	
			end
		end
	end	
	
	if beginruntimer<=0 then
		beginruntimer=4
	end	
	
	-- do the attack run for nme's in the nmeatt collection
	if #nmesatt>0 then nmeattacking() end
	--nmecapture()
	docapture()
	doenemyhit()

	nmealive=false
	
	-- here we are doing the collision checks for non-attacking nme
	-- we're also checking if any are alive for the nmeallalive flag
	for r=1,#playfield do
		for c=1,#playfield[r] do
			if not playfield[r][c].canwrite and playfield[r][c].nme.mode~=2then
				nmealive=true
				if #rounds > 0 and (playfield[r][c].nme.mode==0 or playfield[r][c].nme.mode==1) then
					for rds in all(rounds) do
						if doboxcollision(playfield[r][c].nme.x,playfield[r][c].nme.y,rds.x,rds.y,nmehitboxwidth) then	
							del(rounds,rds)
							if playfield[r][c].nme.hp>1 then
								playfield[r][c].nme.hp-=1
							else
								sfx(1,1) -- nme explode sound
								if playfield[r][c].nme.mode==0 then
									player.score+=nmescores[playfield[r][c].nme.typ]
								else
									player.score+=(nmescores[playfield[r][c].nme.typ]*4)
								end
								add(explosions,{x=playfield[r][c].nme.x,y=playfield[r][c].nme.y,t=1})
								playfield[r][c].nme.mode=2
								playfield[r][c].canwrite=true	
								playfieldnmes-=1
								freelifecheck()
								stagekills+=1
							end
						end		
					end
				end
				drawsprite(playfield[r][c].nme,false)
			end
		end
	end

	doenemyhit()
end

function nmeattacking()
	local dx
	local dy
	local nmeatt
	
	for i = #nmesatt,1,-1 do
		nmeatt=nmesatt[i]
		
		if nmeatt.sw==-1 then
			nmeatt.ph-=0.005
			if nmeatt.ph<=0.5 then
				--nmeatt.ph=1
				nmeatt.sw=nmeatt.sw*-1
			end		
		else
			nmeatt.ph+=0.005
			if nmeatt.ph>=1 then
				--nmeatt.ph=0
				nmeatt.sw=nmeatt.sw*-1
			end	
		end
		
		nmeatt.lax=nmeatt.ax
		nmeatt.lay=nmeatt.ay	
		nmeatt.ax+=0.5*cos(nmeatt.ph)
		nmeatt.ay+= nmeymovespd
		
		dx = (nmeatt.lax-nmeatt.ax)
		dy = (nmeatt.lay-nmeatt.ay)
		ang = atan2( dx, dy )
		
		if	nmeatt.ax <fieldboundmin then
			nmeatt.ax=fieldboundmin
		end
		
		if	nmeatt.ax>fieldboundmax then
			nmeatt.ax=fieldboundmax
		end
		
		if nmeatt.ay>128 then
			local slot=playfield[nmeatt.row][nmeatt.col]

			--if slot==nil then -- should never need this
			--	slot=findemptyslot(nmeatt.typ)
			--end
			
			--if slot.canwrite then
			nmeatt.x=slot.x
			nmeatt.y=slot.y
			nmeatt.ax=slot.x
			nmeatt.ay=slot.y
			nmeatt.mode=0
			
			slot.nme=nmeatt	
			slot.canwrite=false
			--end
			del(nmesatt,nmeatt)
		end
		
		if doboxoverlapcollision(nmeatt.ax,nmeatt.ay,player.x,player.y,8) and player.alive then	
			playerdeath()
			destroynme(nmeatt)
		end		
		
		if #rounds > 0 then
			for r in all(rounds) do
				if doboxcollision(nmeatt.ax,nmeatt.ay,r.x,r.y,nmehitboxwidth) then
					--local pfslot=playfield[nmeatt.row][nmeatt.col].nmeatt

					if nmeatt.hp>1 then
						nmeatt.hp-=1
					else
						destroynme(nmeatt)
						stagekills+=1
					end
				
					del(rounds,r)
				end
			end
		end
			
		drawrotatesprite(ang,nmeatt.ax,nmeatt.ay,nmeatt)
		
	end	
end

function destroynme(nme)
	sfx(1,1) -- nme explode sound
	player.score+=(nmescores[nme.typ]*4)

	add(explosions,{x=nme.ax,y=nme.ay,t=1})
	del(nmesatt,nme)
	freelifecheck()	
end

--function endattackrun(nmeatt, cw)
--	local col=findnextslot(nmeatt.row,nmeatt.col,true)
--	
--	if col>0 then
--		local pfslot=playfield[nmeatt.row][col]
--		
--		if pfslot.canwrite then
--			nmeatt.x=pfslot.x
--			nmeatt.y=pfslot.y
--			nmeatt.ax=pfslot.x
--			nmeatt.ay=pfslot.y
--			nmeatt.mode=0
--			nmeatt.col=col
--			
--			if not cw then
--				pfslot.nme=nmeatt	
--			end
--			
--			pfslot.canwrite=cw
--		end
--		return true
--	else
--		return false
--	end
--end

--function findnextslot(row,ocol,st)
--	if st then
--		if playfield[row][ocol].canwrite and playfield[row][ocol].x>=fieldboundmin and playfield[row][ocol].x<=fieldboundmax then
--			return ocol
--		end
--	end
--
--	for col=1,#playfield[row] do
--		if playfield[row][col].canwrite and playfield[row][col].x>=fieldboundmin and playfield[row][col].x<=fieldboundmax then
--			return col
--		end
--	end	
--	return -1
--end

function findemptyslot(t)
	if t==1 then
		for n=1,16 do	
			local r=mothslots[n][1]
			local c=mothslots[n][2] 
			local slot=playfield[r][c]
			--printh("n="..n,"log.txt")
			if slot.holdslot==false and slot.canwrite==true then 
				slot.holdslot=true
				--printh("----typ=1, r="..r..",c:"..c,"log.txt")
				return slot
			end
		end
	end

	if t==2 then
		for n=1,20 do	
			local r=beeslots[n][1]
			local c=beeslots[n][2]
			local slot=playfield[r][c]
			--printh("n="..n,"log.txt")
			if slot.holdslot==false and slot.canwrite==true then 
				slot.holdslot=true
				--printh("----typ=2, r="..r..",c:"..c,"log.txt")
				return slot
			end
		end
	end

	if t==3 or t==4 then
		for n=1,4 do	
			local r=bossslots[n][1]
			local c=bossslots[n][2]
			local slot=playfield[r][c]
			--printh("n="..n,"log.txt")
			if slot.holdslot==false and slot.canwrite==true then 
				slot.holdslot=true
				--("----typ=3, r="..r..",c:"..c,"log.txt")
				return slot
			end
		end
	end

	--for r=1,#playfield do
	--	for c=1,#playfield[r] do
	--		local slot=playfield[r][c]
	--		if slot.canwrite and slot.holdslot==false and slot.nme.typ==t then
	--			slot.holdslot=true
	--			return slot
	--		end
	--	end	
	--end
	--printh("should never get here","log.txt")
	return nil
end

function drawsprite(nme,flipy)
	nme.t+=nmeanimspd
	if nme.t>(3-nmeanimspd) then
		nme.t=1
	end
	local fr		
	local hp=nme.hp
	if nme.st==0 then
		if nme.typ==1 then
			fr=nmetype1frames[flr(nme.t)]
		elseif nme.typ==2 then
			fr=nmetype2frames[flr(nme.t)]
		elseif nme.typ==3 then
			if hp>1 then
				fr=nmetype3frames[flr(nme.t)]
			else
				fr=nmetype3frames[flr(nme.t)+2]
			end
		end
	end
	nme.f=fr
	--add(drawqueue,{s=nme.f,x=nme.x,y=nme.y,w=1,h=1,flix=false,flipy=flipy})
	queue_spr(nme.f,nme.x,nme.y,1,1,false,flipy)
	--spr(nme.f,nme.x,nme.y,1,1,false,flipy)
end

function drawrotatesprite(ang,x,y,nme)
	local frs={}

	if nme.typ==1 then 
		frs=nmetypeattframes[1]
	elseif nme.typ==2 then 
		frs=nmetypeattframes[2]
	elseif nme.typ==3 and nme.hp==2 then
		frs=nmetypeattframes[3]
	else 
		frs=nmetypeattframes[4]
	end

	local index=flr(ang*24)+1
	local fram={
		{frs[7],false,true},
		{frs[6],false,true},
		{frs[5],false,true},
		{frs[4],false,true},
		{frs[3],false,true},
		{frs[2],false,true},
		{frs[1],true,true},
		{frs[2],true,true},
		{frs[3],true,true},
		{frs[4],true,true},
		{frs[5],true,true},
		{frs[6],true,true},
		{frs[7],true,false},
		{frs[6],true,false},
		{frs[5],true,false},
		{frs[4],true,false},
		{frs[3],true,false},
		{frs[2],true,false},
		{frs[1],false,false},
		{frs[2],false,false},
		{frs[3],false,false},
		{frs[4],false,false},
		{frs[5],false,false},
		{frs[6],false,false}
	}

	--spr(fram[index][1],x,y,1,1,fram[index][2],fram[index][3])
	--add(s=fram[index][1],x=x,y=y,w=1,h=1,flipx=fram[index][2],flipy=fram[index][3])
	queue_spr(fram[index][1],x,y,1,1,fram[index][2],fram[index][3])
	--print(tostr(fram[index][1]),x,y+9,7)
end

function dowave()
	local cyclespersegment=15
	for i=#twave,1,-1 do
		local fromnode
		local tonode
		local nme=twave[i]
		local dist
		local dx
		local dy
		local disttonext
		local maxnodes=0
		local path={}
		
		path=fetchpath(nme.path)
		maxnodes=#path
		
		if nme.st==0 then
			nme.st=1			
			fromnode=path[nme.index]
			
			if nme.index==maxnodes then
				if not ischallengingstage then
					local slot=findemptyslot(nme.typ)
					
					nme.col=slot.col
					nme.row=slot.row
					tonode={x=slot.x,y=slot.y}
				else
					tonode=path[nme.index]
				end
			else 
				tonode=path[nme.index+1]
			end
			
			nme.ph = atan2( (fromnode.x-tonode.x), (fromnode.y-tonode.y) )
			nme.x=fromnode.x
			nme.y=fromnode.y
			nme.ax=tonode.x
			nme.ay=tonode.y
		else 
			dx=nme.ax-nme.x
			dy=nme.ay-nme.y
		
			dist = sqrt(dx*dx + dy*dy)
		
			vx=dx/dist * nmewavespd
			vy=dy/dist * nmewavespd
			
			nme.x+=vx
			nme.y+=vy
		end

		disttonext = (abs(nme.x-nme.ax)+abs(nme.y-nme.ay)) 

		if disttonext<nmewavespd then
			nme.index+=1
			nme.st=0
		end
		
		if nme.index>maxnodes then
			if not ischallengingstage then
				
				local slot=playfield[nme.row][nme.col]

				nme.x=slot.x
				nme.y=slot.y
				nme.ax=slot.x
				nme.ay=slot.y

				nme.mode=0
				nme.index=1

				slot.nme = nme
				slot.canwrite=false
				slot.holdslot=false
				playfieldnmes+=1
			else
			
			end

			del(twave,nme)
			nmewavenmes-=1
		end
		
		if #rounds > 0 and nme.mode==3 then
			for r in all(rounds) do
				if doboxcollision(nme.x,nme.y,r.x,r.y,nmehitboxwidth) then
					--printh("nme.mode:" .. nme.mode, logfile)
					del(rounds,r)
					if nme.hp>1 then
						nme.hp-=1
					else
						sfx(1,1) -- nme explode sound
						player.score+=(nmescores[nme.typ]*4)

						add(explosions,{x=nme.x,y=nme.y,t=1})
						freelifecheck()		
						del(twave,nme)
						nmewavenmes-=1
						nme.mode=2
						stagekills+=1
						if nme.row>0 and nme.col>0 then
							playfield[nme.row][nme.col].holdslot=false	
						end
					end
				end
			end
		end
		if stage>1 then
			if not ischallengingstage then
				doenemyfireroll(nme,false,40,60)
			end
		end

		if nme.mode==3 then
			drawrotatesprite(nme.ph,nme.x,nme.y,nme)
		end	
	end
end

function docapture()
	if #nmescap>0 then
		local cyclespersegment=15
		local fromnode
		local tonode
		local nme=nmescap[1]	
		local dist
		local dx
		local dy
		local vx=0
		local vy=0
		local disttonext
		local maxnodes=0
		local path={}
		
		path=paths[8]
		maxnodes=#path

		--printh("path:"..#path,"log.txt")
		--printh("nme.index:"..nme.index,"log.txt")
		if nme.index~=6 then
			if not tractoron then
				if nme.st==0 then
					nme.st=1			
					--fromnode=path[nme.index]
					fromnode={x=nme.x,y=nme.y}
					
					--printh("fromnode:"..tostr(fromnode),"log.txt")
					
					if nme.index==maxnodes then
						local slot=playfield[nme.row][nme.col]
						tonode={x=slot.x,y=slot.y}				
					else 
						tonode=path[nme.index+1]
						--("fromnode:{x="..fromnode.x..",y="..fromnode.y.."}. tonode:{x="..tonode.x..",y="..tonode.y.."}.","log.txt")
					end
					
					nme.ph = atan2( (fromnode.x-tonode.x), (fromnode.y-tonode.y) )
					nme.x=fromnode.x
					nme.y=fromnode.y
					nme.ax=tonode.x
					nme.ay=tonode.y
					
					--printh("first time - nme:{ax="..nme.ax..",ay="..nme.ay.."}. nme:{x="..nme.x..",y="..nme.y.."}.","log.txt")
				else 
					dx=nme.ax-nme.x
					dy=nme.ay-nme.y

					--printh("nme:{ax="..nme.ax..",ay="..nme.ay.."}. nme:{x="..nme.x..",y="..nme.y.."}.","log.txt")
				
					dist = sqrt(dx*dx + dy*dy)
				
					vx=dx/dist * nmeymovespd
					vy=dy/dist * nmeymovespd
					
					nme.x+=vx
					nme.y+=vy
				end

				disttonext = (abs(nme.x-nme.ax)+abs(nme.y-nme.ay)) 
				--printh("nmewavespd:"..tostr(nmewavespd).."disttonext:"..tostr(disttonext),"log.txt")

				if disttonext<nmewavespd then
					nme.index+=1
					nme.st=0
				end
				
				if nme.index>maxnodes then
					local slot=playfield[nme.row][nme.col]

					nme.x=slot.x
					nme.y=slot.y
					nme.ax=slot.x
					nme.ay=slot.y

					nme.mode=0

					slot.nme = nme
					slot.canwrite=false
					slot.holdslot=false
					nme.index=1
					playfieldnmes+=1
				
					del(nmescap,nme)
				end
			else
				nme.ph=0.25	
				drawtractorbeam(nme.x-7,nme.y+8)	
				
			end					
		else			
			nme.index=7
			tractoron=true
			musicswitch=true
		end

		if #rounds > 0 then
			for r in all(rounds) do
				if doboxcollision(nme.x,nme.y,r.x,r.y,nmehitboxwidth) then
					--local pfslot=playfield[nmeatt.row][nmeatt.col].nmeatt

					if nme.hp>1 then
						nme.hp-=1
					else
						sfx(1,1) -- nme explode sound
						player.score+=(nmescores[nme.typ]*4)

						add(explosions,{x=nme.x,y=nme.y,t=1})
						del(nmescap,nme)
						freelifecheck()	
						tractoron=false
						resettractor()
						stagekills+=1
					end
				
					del(rounds,r)
				end
			end
		end

		drawrotatesprite(nme.ph,nme.x,nme.y,nme)
		
	end
end

function doenemyfireroll(nme,st,min,max)
	local rndm=rnd(4)
	if flr((rndm==1 or rndm==2 or rndm==3)) and player.alive and #nmerounds<7 and (nme.y>min and nme.y<max) and (firesduringwave<maxfiresperwave or st) then
		local dx = (player.x+3) - nme.x
		local dy = (player.y+2) - nme.y

		local dist = sqrt(dx*dx + dy*dy)
		local velx = (dx / dist) * missilemovespd
		local vely = (dy / dist) * missilemovespd
		
		add(nmerounds,{x=nme.x,y=nme.y,vx=velx,vy=vely,tx=player.x,ty=player.y})
		firesduringwave+=1
	end
end