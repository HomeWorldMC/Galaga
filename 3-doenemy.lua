function doplayfieldmovement()
	if (playfield[1][10].x>fieldboundmax or playfield[1][1].x<fieldboundmin) then
		nmexmovespd=nmexmovespd*-1
	end	

	beginruntimer-=0.15	
	nmecount=0	
	
	for r=1,#playfield do -- move enemy and roll deice for attack run
		for c=1,#playfield[r] do
			local pf=playfield[r][c]

			pf.x+=nmexmovespd
			
			if not pf.canwrite and pf.nme.mode==0 then	
				nmecount+=1
				pf.nme.x=pf.x
				
				if beginruntimer<0 and flr(rnd(nmecount*4)+1)==1 and #nmesatt<numattackers and player.alive and gamephase==3 and not disableplayer then
					beginruntimer=4
					pf.nme.mode=1
					pf.nme.ax=pf.nme.x
					pf.nme.ay=pf.nme.y
					pf.nme.ph=rnd(1)

					if pf.nme.typ==3 and #nmescap==0 and flr(rnd(2))==0 and not triedcapturethisstage and player.p==1 and gamephase==3 then
						add(nmescap,pf.nme)
						triedcapturethisstage=true					
					else
						add(nmesatt,pf.nme)
						doenemyfireroll(pf.nme,true,0,70)
					end

					pf.canwrite=true
					pf.holdslot=false

					--playfieldnmes-=1						
					sfx(6,3) -- nme attack run sound
				end	
			end
		end
	end	

	playfieldnmes = nmecount
	
	if beginruntimer<=0 then
		beginruntimer=4
	end	
end

function doplayfield()
	nmealive=false
	
	for r=1,#playfield do
		for c=1,#playfield[r] do
			local pf=playfield[r][c]

			if not pf.canwrite and pf.nme.mode~=2 then
				nmealive=true
				if #rounds > 0 and (pf.nme.mode==0 or pf.nme.mode==1) then
					for rds in all(rounds) do
						if checkrounds(pf.nme,rds,1) then
							pf.nme.mode=2
							pf.canwrite=true	
							--playfieldnmes-=1
						else
							if pf.nme.hascapture then
								if checkrounds({x=pf.nme.x,y=pf.nme.y-9,hp=1,typ=3},rds,1) then
									pf.nme.hascapture=false
								end
							end	
						end
					end
				end
				drawsprite(pf.nme,false)
				if pf.nme.hascapture then
					queue_spr(23, pf.nme.x, pf.nme.y-9, 1, 1, false, false)
				end
			end
		end
	end
end

function doattacking()
	if #nmesatt>0 then
		local dx
		local dy
		local nmeatt
		
		for i = #nmesatt,1,-1 do
			nmeatt=nmesatt[i]
			
			if nmeatt.sw==-1 then
				nmeatt.ph-=0.005
				if nmeatt.ph<=0.5 then
					nmeatt.sw=nmeatt.sw*-1
				end		
			else
				nmeatt.ph+=0.005
				if nmeatt.ph>=1 then
					nmeatt.sw=nmeatt.sw*-1
				end	
			end
			
			nmeatt.lax=nmeatt.x
			nmeatt.lay=nmeatt.y	
			nmeatt.x+=0.5*cos(nmeatt.ph)
			nmeatt.y+= nmeymovespd
			
			dx = (nmeatt.lax-nmeatt.x)
			dy = (nmeatt.lay-nmeatt.y)
			ang = atan2( dx, dy )
			
			if	nmeatt.x <fieldboundmin then
				nmeatt.x=fieldboundmin
			end
			
			if	nmeatt.x>fieldboundmax then
				nmeatt.x=fieldboundmax
			end
			
			if nmeatt.y>128 then
				local slot=playfield[nmeatt.row][nmeatt.col]

				nmeatt.x=slot.x
				nmeatt.y=slot.y
				nmeatt.mode=0
				
				slot.nme=nmeatt	
				slot.canwrite=false
				playfieldnmes+=1
				del(nmesatt,nmeatt)
			end
			
			if dorectoverlapcollision(nmeatt.x,nmeatt.y,player.x,player.y,8,8,8,8) and player.alive and not disableplayer then
				playerdeath()
				sfx(1,1) -- nme explode sound
				player.score+=(nmescores[nmeatt.typ]*4)
				add(explosions,{x=nmeatt.x,y=nmeatt.y,t=1})
				del(nmesatt,nmeatt)
				freelifecheck()	
			end		
			
			if #rounds > 0 then
				for r in all(rounds) do
					if checkrounds(nmeatt,r,4) then
						del(nmesatt,nmeatt)
						if nmeatt.hascapture then
							dorecapture(nmeatt)
						end
					else
						if nmeatt.hascapture then
							sp.x=nmeatt.x
							sp.y=nmeatt.y-9
							if checkrounds(sp,r,1) then
								nmeatt.hascapture=false
							end
						end
					end
				end
			end
				
			drawrotatesprite(ang,nmeatt.x,nmeatt.y,nmeatt)
			if nmeatt.hascapture then
				queue_spr(23, nmeatt.x+1, nmeatt.y-9, 1, 1, false, false)
			end
		end	
	end
end

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
	queue_spr(nme.f,nme.x,nme.y,1,1,false,flipy)
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
	queue_spr(fram[index][1],x,y,1,1,fram[index][2],fram[index][3])
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
		local slot
		
		path=fetchpath(nme.path)
		maxnodes=#path
		
		if nme.st==0 then
			nme.st=1			
			fromnode=path[nme.index]
			
			if nme.index==maxnodes then
				if not ischallengingstage then
					slot=findemptyslot(nme.typ)
					
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
				
				slot=playfield[nme.row][nme.col]

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
				if checkrounds(nme,r,1) then
					nmewavenmes-=1
					nme.mode=2
					if nme.row>0 and nme.col>0 then
						playfield[nme.row][nme.col].holdslot=false
					end
					del(twave,nme)
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
		local slot
		
		path=paths[8]
		maxnodes=#path

		if nme.index~=6 then
			if not tractoron then
				if nme.st==0 then
					nme.st=1			
					fromnode={x=nme.x,y=nme.y}
					
					if nme.index==maxnodes then
						slot=playfield[nme.row][nme.col]
						tonode={x=slot.x,y=slot.y}				
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
				
					vx=dx/dist * nmeymovespd
					vy=dy/dist * nmeymovespd
					
					nme.x+=vx
					nme.y+=vy
				end

				disttonext = (abs(nme.x-nme.ax)+abs(nme.y-nme.ay)) 

				if disttonext<nmewavespd then
					nme.index+=1
					nme.st=0
				end
				
				if nme.index>maxnodes then
					slot=playfield[nme.row][nme.col]

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
				dotractorbeam(nme.x-7,nme.y+8,nme)
			end					
		else			
			nme.index=7
			tractoron=true
			musicswitch=true
		end

		if #rounds > 0 then
			for r in all(rounds) do
				if checkrounds(nme,r,4) and not disableplayer and not nme.isimmortal then
					tractoron=false
					resettractor()
					del(nmescap,nme)
					music(-1)
				end
			end
		end

		drawrotatesprite(nme.ph,nme.x,nme.y,nme)
		if nme.hascapture then
			queue_spr(23, nme.x+1, nme.y+8, 1, 1, false, false)
		end		
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

function checkrounds(nme,round,bonus)
	if doboxcollision(nme.x,nme.y,round.x,round.y,nmehitboxwidth) and not disableplayer and not nme.isimmortal then	
		del(rounds,round)
		if nme.hp>1 then
			nme.hp-=1
			return false
		else
			nme.hp-=1
			sfx(1,1) -- nme explode sound
			player.score+=(nmescores[nme.typ]*bonus)
			add(explosions,{x=nme.x,y=nme.y,t=1})
			freelifecheck()
			stagekills+=1
			return true
		end		
	end	
	return false
end