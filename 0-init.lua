function _init()
	-- disable key repeat
	
	--poke(0x5f2e, 1)

	--spare colors 15,2,11

	initialiseconstants()
	
	invince=false
	if invince then
		maxrounds=5
		musicstart=3
	else
		maxrounds=2
		musicstart=1
		poke(0x5f5c,255)
		poke(0x5f5d,255)
	end
		
	timers={}
	cycletimers={}
	movetimers={}

	-- Vars
	blink=0	
	firsttime=true
	maxfreelives=#freelifescores
	freelivesgiven=1
	gamephase=0
	gameover=true
	player={x=63,y=116,lives=2,alive=true,t=0,f=16,animlock=1,score=0}
	nmewavespd=1.75
	wavetimer=3
	wavecounter=1
	starsx={}
	starsy={}
	twave={}
	nmewavenmes=0
	stage=1
	maxfiresperwave=2
	musicstate=-1
	sfxon=false
	jankymusictimer=0
	stagekills=0
	bon=0		
	ischallengingstage=false
	bonusflag=false	
	shipspeedx=1.25
	wavesetval=1
	playfieldnmes=0
	pausetimer=2

	tractoron=false
	tractorendtimer=10

	tractorfx=8

	musicswitch=false
	challengingmusicswitch=false
	stagesfx=false

	disableplayer=false
	
	tcol=1

	trmov=5
	trdir=1

	triedcapturethisstage=false

	drawqueue={}
	tractorqueue={}
	printqueue={}
	rectqueue={}
	swapgamephase=6

	endofstage=false

	--testsprite={x=10,y=10,s=10}
	--move({x=100,y=100}, testsprite)

	initialisestars()
end

function _update60()
	update_timers(1/30)
	update_cycletimers(1/30)
	update_movetimers(1/30)

	musicstate=stat(24)

	if musicstate==3 then
		jankymusictimer+=0.1
		if jankymusictimer>5 then
			music(-1)
			jankymusictimer=0
		end
	end

	if (gamephase==1 or gamephase==2 or gamephase==3 or gamephase==4 or gamephase==6 or gamephase==7) and player.alive and not disableplayer then
		controls()	
	else
		getshieldnumbers()
		if btnp(🅾️) and (gamephase==0 or gamephase==8) then
			gamephase=1
		end
	end

	if gamephase==1 then
		-- check if this stage is a challenging stage
		if (stage+1)%4==0 then
			ischallengingstage=true
			nmewavespd=1.25		
		else
			ischallengingstage=false
			nmewavespd=1.75
		end

		getshieldnumbers()

		if musicstate < 0 then
			if gameover then
				startgame()
			else 
				resetvars()
				initialisestage()
				getshieldnumbers()

				dolog("gamephase-info-moving")
				gamephase=7
				swapgamephase=2
				dolog("gamephase-info-to")
				after(2, function() 
					gamephase=swapgamephase	
					dolog("gamephase-info-switched")
				end)
				stagesfx=true
			end
		end
	elseif gamephase==2 then -- first wave attacks		
		maingame()
		prepwaves()		
		if nmewavenmes==0 then -- all wave enemies defeated or moved to the playfield. 
			if wavecounter==#nmewavequeue then	-- all waves completed. move to formation attack phase (game phase 3)
				if not ischallengingstage then
					if musicstate < 0 then
						dolog("gamephase-info-moving")
						gamephase=6
						swapgamephase=3
						dolog("gamephase-info-to")
						after(0, function()
							gamephase=swapgamephase
							dolog("gamephase-info-switched")
						end)
					else
						doCSScreen()
						if musicstate==7 then
							jankymusictimer+=0.1
							if jankymusictimer>5 then
								music(-1)
								jankymusictimer=0
							end
						end
					end
				else
					--do end of challenging stage stuff here
					if musicstate < 0 then
						printh("--end of challenging stage-- ischallengingstage="..tostr(ischallengingstage),"log.txt")
						music(5)
						ischallengingstage=false
						challengingmusicswitch=false
						bonusflag=true
					end
				end
			end
		else
			if not player.alive then -- player died during wave attack. move to game phase 5 (player respawn)
				dolog("gamephase-info-moving")
				gamephase=6
				swapgamephase=5
				dolog("gamephase-info-to")
				after(1.5, function()
					gamephase=swapgamephase
					dolog("gamephase-info-switched")
				end)
				lastgamephase=2
			end
		end
	elseif gamephase==3 then --- formation attacks
		maingame()
		if musicswitch then
			music(tractorfx)
			musicswitch=false
		end

		if not tractoron then
			music(-1)
		end

		if #nmesatt==0 and #nmescap==0  then
			if not nmealive and playfieldnmes<=0 then
				if player.alive then -- all waves and formations cleared. move to next stage
					getshieldnumbers()
					rounds={}
					nmerounds={}
					fire=0
					stagekills=0
					playfieldnmes=0
					dolog("gamephase-info-moving")
					gamephase=6
					swapgamephase=4
					dolog("gamephase-info-to")
					after(1.5, function()
						gamephase=swapgamephase
						dolog("gamephase-info-switched")
					end)
				else
					dolog("gamephase-info-moving")
					gamephase=6
					swapgamephase=5
					dolog("gamephase-info-to")
					after(1.5, function()
						gamephase=swapgamephase
						dolog("gamephase-info-switched")
					end)
				end
			else
				if not player.alive then -- player died during formation attack. move to game phase 5 (player respawn)
					dolog("gamephase-info-moving")
					gamephase=6
					swapgamephase=5
					dolog("gamephase-info-to")
					after(1.5, function()
						gamephase=swapgamephase
						dolog("gamephase-info-switched")
					end)
				end
			end
		end
	elseif gamephase==4 then --enemies cleared
		maingame()	
		wavesetval+=1
		if wavesetval>3 then
			wavesetval=1
		end
		dolog("gamephase-info-moving")
		gamephase=6
		swapgamephase=1
		dolog("gamephase-info-to")
		after(1.5, function() 
			gamephase=swapgamephase
			dolog("gamephase-info-switched")
		end)
		stage+=1
	elseif gamephase==5 then -- player dead
		maingame()
		if player.lives<0 then
			dolog("gamephase-info-moving")
			gamephase=6
			swapgamephase=8
			dolog("gamephase-info-to")
			after(0, function()
				gamephase=swapgamephase
				dolog("gamephase-info-switched")
			end)
		else
			if not tractoron then
				if #nmesatt==0 then
					player.x=63
					player.y=112
					player.f=16
					disableplayer=false
					dolog("gamephase-info-moving")
					gamephase=6
					swapgamephase=lastgamephase
					dolog("gamephase-info-to")
					after(1.5, function() 
						gamephase=swapgamephase
						dolog("gamephase-info-switched")
						player.alive=true
					end)
				end
			end
		end
	end

	if gamephase==6 then
		maingame()
	end

	if gamephase==7 then
		maingame()
		stageUI()		
		setstageicons()
		setlivesicons()
		if stagesfx and stage>1 then
			if ischallengingstage then	
				music(4)
			else
				sfx(5,3)
			end
			stagesfx=false
		end
	end

	if gamephase==8 then -- game over
		maingame()
		startscreen()
	end

	if gamephase>1 then
		setstageicons()
		setlivesicons()
	end
end
	
function _draw()
	cls(0)
	dostarfield()

	--print("gamephase:"..gamephase,5,30,7) 
	
	--flush_rectfillq()
	flush_drawq()
	flush_drawqt()
	flush_rectq()
	flush_printq()

	if gamephase==0 or gamephase==1 or gamephase==8 then
		startscreen()
	end

	rect(0,0,127,127,7)

	

	flush_printq()
end

function doCSScreen()
	if musicstate>=5 then
		queue_prt("number of hits ", 30,63,textcol)
	end

	if musicstate>=6 then
		if stagekills==40 then
			queue_prt("perfect !",46,49,8)
		end
		queue_prt(stagekills, 90,63,textcol)
	end

	if musicstate==7 then				
		if bonusflag then
			if stagekills<40 then
				bon=(stagekills*10)
			else
				bon=1000
			end
			player.score+=(bon)
			bonusflag=false
		end
		if stagekills<40 then
			queue_prt("bonus " .. (bon), 44,77,textcol)
		else
			queue_prt("special bonus " .. (bon) .. " pts", 22,77,10)
		end
	end
end

function controls() 
	if btn(⬅️) then
		if player.x>5 then
			player.x-=shipspeedx
		end
	end
	
	if btn(➡️) then
		if player.x<115 then
			player.x+=shipspeedx
		end
	end
	
	if btnp(❎) then
		--if (gamephase==2 or gamephase==3 or (gamephase==6 and swapgamephase==2) or (gamephase==6 and swapgamephase==3)) then
		if player.alive and rounds~=nil then
			fire=1
		end
	end
	
	if fire==1 and #rounds<maxrounds then
		firelaser()
	end
end

function freelifecheck()
	if freelivesgiven <= maxfreelives and player.score>=freelifescores[freelivesgiven] then
		player.lives+=1
		freelivesgiven+=1
		sfx(7,0) --free life sound
	end
end

function startgame()
	--sfx(4,0) -- start game sound
	music(musicstart)
	
	player={x=63,y=116,lives=2,alive=true,t=0,f=16,animlock=1,score=0,captured=false, capturedby=nil}
	--playerlifetimer=7
	gameover=false
	firsttime=false
	stage=1
end

function initialisestage()
	fire=0	
	rounds={}
	nmerounds={}	
	nmesatt={}	
	nmewave={}
	nmescap={}	
	nmewavequeue={}
	explosions={}
	playerexplosion=0
	nmealive=true
	nmecount=40
	beginruntimer=0
	lastgamephase=2	
	playfield={}
	numshields={}	
	firesduringwave=0
	wavetimer=3
	wavecounter=1
	twave={}
	nmewavenmes=0
	respawndelay=5
	triedcapturethisstage=false

	local nmex=12
	local nmey=8
	
	-- Create playfield
	for r=1,5 do
		add(playfield,{})
		for c=1,10 do
			local nme={x=nmex,y=nmey,ax=nmex,ay=nmey,lax=nmex,lay=nmey,f=1,st=0,dir=0,typ=typ[r],t=1,ph=0,sw=flr(rnd(2)) * 2 - 1,col=c,row=r,mode=0,timer=3,dr=0.5,hp=hp[r]}
			add(playfield[r],{x=nme.x, y=nme.y, nme=nme,row=r,col=c,canwrite=true,holdslot=false})
			nmex+=12
		end	
		nmey+=10
		nmex=12
	end	

	-- Create first wave nmes, add to wave set, then add wave set to wave queue
	--local nme={}
	local ws=1
	for n=1,5 do
		ws=stage%#waves
		if ws==0 then ws=#waves end
		buildstagenmewaves(waves[ws][n])
	end
	nmewavenmes=40
end

function buildstagenmewaves(wav)
	local wavset={}
	local hp=1
	local nme

	ntindex=1
	ptindex=1

	if wav[1]==1 then nw=1 else nw=2 end
	for i=1,(8/wav[1]) do			
		if wav[2][ntindex]==3 then hp=2 else hp=1 end
		
		for nw=1, wav[1] do
			nme={x=0,y=0,ax=0,ay=0,lax=0,lay=0,f=1,st=0,dir=0,typ=wav[2][ntindex],t=1,ph=0,sw=flr(rnd(2))*2-1,col=0,
				row=0,mode=3,timer=3,dr=0.5,hp=hp,path=wav[3][ptindex],hascapture=false,index=1}
			add(wavset,nme)
			
			ntindex+=1
			ptindex+=1
			if ntindex>#wav[2] then ntindex=1 end
			if ptindex>#wav[3] then ptindex=1 end
		end
	end
	add(nmewavequeue, {wav[1],wavset})
end

function resetvars() 
	fire=0	
	rounds={}
	nmerounds={}	
	nmesatt={}
	nmescap={}
	explosions={}
	playerexplosion=0
	nmecount=40
	beginruntimer=0
	playfield={}
	triedcapturethisstage=false
	
end

function initialisestars()
	cols={5,13,1}
	stars={}
	
	local speed=1
	for j=1,3 do
		
		for i=1,30 do
			add(starsx,rnd(126)+1)
			add(starsy,rnd(126)+1)
			
			add(stars,{x=rnd(126),y=rnd(126),col=cols[j],spd=speed})			
		end
		speed-=0.25
	end
end

function doexplosions()
	for n=#explosions,1,-1 do
		--spr(explosionsframes[flr(explosions[n].t)],explosions[n].x,explosions[n].y)
		queue_spr(explosionsframes[flr(explosions[n].t)],explosions[n].x,explosions[n].y,1,1,false,false)
		explosions[n].t+=explosionspd
		if explosions[n].t>(6-explosionspd) then
			del(explosions,explosions[n])
		end
	end
end

function doplayerexplosion()	
	if playerexplosion~=0 then
		queue_spr(playerexplosionframes[flr(playerexplosion.t)],playerexplosion.x-5,playerexplosion.y-3,2,2,false,false)
		playerexplosion.t+=(explosionspd/3)
		if playerexplosion.t>(5-explosionspd) then
			playerexplosion=0
		end
	end
end

function fetchpath(p)
	local path_index=tonum(sub(p, 1, 1))
	local path_type=sub(p, 2,2)
	local path=paths[path_index]

	if path_type=="b" then
		path=flippath(path)
	end
	
	return path
end

function flippath(path)
	local flippedpath={}
	for i in all(path) do
		add(flippedpath,{x=128-i.x,y=i.y})
	end
	return flippedpath
end

function resettractor()
	tractorfx=8
	trdir=1
	trmov=5
	tractorendtimer=10
end

function dotractorbeam(offx,offy,nme)
	tractorfx=8
	queue_sspr(0, 32, 24, trmov, offx, offy, 24, trmov)

	local c1=tcols1[flr(tcol)]
	local c2=tcols2[flr(tcol)]
	local c3=tcols3[flr(tcol)]

	tcol+=0.3
	if tcol>3.8 then tcol=1 end

	pal(2,c1,1)
	pal(11,c2,1)
	pal(15,c3,1)

	trmov+=0.35*trdir
	if trmov>40  then 		
		tractorendtimer-=0.075
		if tractorendtimer<0 then
			tractorfx=10
			musicswitch=true
			trdir=-1 
			trmov=40
		else
			trmov=41
		end	

		if dorectoverlapcollision(player.x,player.y,offx+6,offy,6,8,10,39) and not disableplayer and tractoron then
			disableplayer=true
			

			cycle(3, 0.02, function(ang, r)
				player.f=drawplayersprite(ang,player.x,player.y)
			end)
			move({x=player.x,y=player.y},{x=nme.x+1,y=player.y-8})
			move({x=nme.x+1,y=player.y-8},{x=nme.x+1,y=nme.y+7})
		end
	end
	
	if trmov<5 then
		tractoron=false 
		trdir=1
		trmov=5
		tractorendtimer=10
		-- do next fighter routines	
		if disableplayer then
			playercapture()	
			player.f=0
			nme.hascapture=true
		end
	end
end

function queue_rect(x1,y1,x2,y2,col)
	add(rectqueue, {
		x1=x1,y1=y1,x2=x2,y2=y2,col=col
	})
end

function queue_spr(n, x, y, w, h, flip_x, flip_y)
  add(drawqueue, {
    n=n, x=x, y=y,
    w=w or 1, h=h or 1,
    fx=flip_x, fy=flip_y
  })
end

function queue_sspr(sx, sy, sw, sh, dx, dy, dw,dh)
  add(tractorqueue, {
    sx=sx, sy=sy, sw=sw, sh=sh, dx=dx, dy=dy, dw=dw,dh=dh
  })
end

function queue_prt(txt, x, y, col)
  add(printqueue, {
    t=txt, x=x, y=y,
    c=col
  })
end

function flush_drawqt()
  for d in all(tractorqueue) do
    sspr(d.sx, d.sy, d.sw, d.sh, d.dx, d.dy, d.dw, d.dh)
  end
  tractorqueue = {}
end

function flush_drawq()
  for d in all(drawqueue) do
    spr(d.n, d.x, d.y, d.w, d.h, d.fx, d.fy)
  end
  drawqueue = {}
end

function flush_printq()
  for d in all(printqueue) do
	print(d.t,d.x,d.y,d.c)
  end
  printqueue = {}
end

function flush_rectq()
	for r in all(rectqueue) do
		rect(r.x1,r.y1,r.x2,r.y2,r.col)
	end
	rectqueue = {}
end

function startscreen()
	local x=32
	local y=20
	local xoff=0
	local yoff=0
	local ymov=0

	if gamephase==8 then
		ymov=46
	end

	queue_sspr(24, 32, 64, 24, x, y+ymov, 64,24)

	print("rEMADE",49,39+ymov,13)
	print("bY",58,45+ymov,13)
	print("tEX",67,45+ymov,13)
	if gamephase==0 or gamephase==8 then
		if firsttime then
			print("[press start to play]", 22,113,textcol)
		else
			print("game over", 45,106,textcol)
			print("[press start to play again]", 10,113,textcol)
		end	
	end
end

function stageUI()
	if ischallengingstage then
		--print("challenging stage",30,64,textcol) -- 68  (128-68)/2 = 60/2 = 30
		queue_prt("challenging stage",30,64,textcol)
	else
		--print("stage " .. stage,50,64,textcol)
		queue_prt("stage " .. stage,50,64,textcol)
	end	
end

function maingame()
	doenemy()
	dowave()
	if gamephase~=5 then
		doplayer()
	end
	doexplosions()
	doplayerexplosion()

	animateplayerrounds(rounds,1,-1)
	animateenemyrounds(nmerounds,2,1) 
end

function prepwaves()
	pausetimer-=0.1
	if pausetimer<=0 then
		wavetimer-=0.35
		if wavetimer<=0 and wavecounter<=#nmewavequeue then	
			local wave=nmewavequeue[wavecounter]
			if wave[2] ~= nil and #wave[2]>0 then	
				for i=1,wave[1] do
					local nme=wave[2][1]
					add(twave, nme)
					del(wave[2],nme)
				end
				wavetimer=3				
			end

			if #twave<=0 then
				if wavecounter~=#nmewavequeue then
					wavecounter+=1
				end
				firesduringwave=0
				if ischallengingstage then
					pausetimer=5
				else
					pausetimer=3	
				end
			end
		end
	end
end

function dolog(num)
	if num=="gamephase-info-moving" then
		printh("Moving from - gamephase="..gamephase..", swapgamephase="..swapgamephase..". Is challenging stage: "..tostr(ischallengingstage),"log.txt")	
	elseif num=="gamephase-info-to" then
		printh("	to - gamephase="..gamephase..", swapgamephase="..swapgamephase,"log.txt")
	elseif num=="gamephase-info-switched" then
		printh("	switched - gamephase="..gamephase..". swapgamephase="..swapgamephase,"log.txt")
	elseif num=="gamephase-info-moving2" then
		printh("Moving from - gamephase="..gamephase.." to 1, is challenging stage: "..tostr(ischallengingstage),"log.txt")
	elseif num=="show-stage-title" then
		printh("--show Stage title--","log.txt")
	else
		printh("{no log entry for that}","log.txt")
	end
end