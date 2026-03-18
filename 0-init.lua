function _init()
	-- disable key repeat
	
	--poke(0x5f2e, 1)
	
	-- Constants	
	pi=3.141592
	logfile="galaga/log.txt"

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
		
	typ={3,1,1,2,2}
	hp={2,1,1,1,1}

	font={a=192,b=193,c=194,d=195,e=196,f=197,g=198,h=199,i=200,j=201,k=202,l=203,m=204,n=205,o=206,p=207,q=208,r=209,s=210,t=211,u=212,v=213,w=214,x=215,y=216,z=217}
	font["0"]=218
	font["1"]=219
	font["2"]=220
	font["3"]=221
	font["4"]=222	
	font["5"]=223
	font["6"]=224
	font["7"]=225
	font["8"]=226
	font["9"]=227
	
	font2={a=228,b=229,c=230,d=231,e=232,f=233,g=234,h=235,i=236,j=237,k=238,l=239,m=240,n=241,o=242,p=243,q=244,r=245,s=246,t=247,u=248,v=249,w=250,x=251,y=252,z=253}
	font2["0"]=218
	font2["1"]=219
	font2["2"]=220
	font2["3"]=221
	font2["4"]=222	
	font2["5"]=223
	font2["6"]=224
	font2["7"]=225
	font2["8"]=226
	font2["9"]=227

	fontspaces= {1,1,1,1,0,0,1,1,0,1,1,0,1,1,2,1,1,1,0,0,1,1,1,1,0,1,-1,1,1,1,1,1,1,1,1,1}

	fontspaces2={2,2,2,2,2,2,2,2,3,2,2,2,1,2,2,2,2,2,2,3,2,1,1,1,3,2,-1,1,1,1,1,1,1,1,1,1}

	nmescores={5,5,20}
	freelifescores={2000,3800,5800,8000,10400,13000,15800,18800,22000,25400,29000,32800,36800,40000}

	nmehitboxwidth=7
	
	fieldboundmin=2
	fieldboundmax=120
	
	explosionsframes={3,4,5,6,7}
	explosionspd=0.4
	
	stageiconsprites={8,9,10,11,12,13}
	
	nmetype1frames={64,65}
	nmetype2frames={72,73}
	nmetype3frames={80,81,88,89}	

	nmetypeattframes={{65,66,67,68,69,70,71},{73,74,75,76,77,78,79},{81,82,83,84,85,86,87},{89,90,91,92,93,94,95}}	

	nmeanimspd=0.035
	nmexmovespd=0.15
	nmeymovespd=0.85
	missilemovespd=1.55

	ischallengingstage=false
	bonusflag=false
	
	shipspeedx=1.25

	wavesetval=1

	beeslots={{5,5},{5,6},{4,5},{4,6},{5,4},{5,3},{4,4},{4,3},{5,7},{5,8},{4,7},{4,8},{5,2},{5,1},{4,2},{4,1},{5,9},{5,10},{4,9},{4,10}}
	mothslots={{3,5},{3,6},{2,5},{2,6},{3,4},{3,3},{2,4},{2,3},{3,7},{3,8},{2,7},{2,8},{3,2},{2,2},{3,9},{2,9}}
	bossslots={{1,5},{1,6},{1,4},{1,7}} 

	wrv={2,1,1,1,1}
	wrv2={2,2,2,2,2}
	
	playfieldnmes=0

	wd1={
		{{1,1,"1a"},{2,1,"1b"},{1,1,"1a"},{2,1,"1b"},{1,1,"1a"},{2,1,"1b"},{1,1,"1a"},{2,1,"1b"}},
		{{3,2,"2b"},{1,1,"2b"},{3,2,"2b"},{1,1,"2b"},{3,2,"2b"},{1,1,"2b"},{3,2,"2b"},{1,1,"2b"}},
		{{1,1,"2a"},{1,1,"2a"},{1,1,"2a"},{1,1,"2a"},{1,1,"2a"},{1,1,"2a"},{1,1,"2a"},{1,1,"2a"}},
		{{2,1,"1b"},{2,1,"1b"},{2,1,"1b"},{2,1,"1b"},{2,1,"1b"},{2,1,"1b"},{2,1,"1b"},{2,1,"1b"}},
		{{2,1,"1a"},{2,1,"1a"},{2,1,"1a"},{2,1,"1a"},{2,1,"1a"},{2,1,"1a"},{2,1,"1a"},{2,1,"1a"}}
	}

	wd2={
		{{1,1,"1a"},{2,1,"1b"},{1,1,"1a"},{2,1,"1b"},{1,1,"1a"},{2,1,"1b"},{1,1,"1a"},{2,1,"1b"}},
		{{3,2,"3a"},{1,1,"4a"},{3,2,"3a"},{1,1,"4a"},{3,2,"3a"},{1,1,"4a"},{3,2,"3a"},{1,1,"4a"}},
		{{1,1,"3b"},{1,1,"4b"},{1,1,"3b"},{1,1,"4b"},{1,1,"3b"},{1,1,"4b"},{1,1,"3b"},{1,1,"4b"}},
		{{2,1,"1a"},{2,1,"5a"},{2,1,"1a"},{2,1,"5a"},{2,1,"1a"},{2,1,"5a"},{2,1,"1a"},{2,1,"5a"}},
		{{2,1,"1b"},{2,1,"5b"},{2,1,"1b"},{2,1,"5b"},{2,1,"1b"},{2,1,"5b"},{2,1,"1b"},{2,1,"5b"}}
	}

    wd3={
        {{2,1,"6a"},{2,1,"6b"},{2,1,"6a"},{2,1,"6b"},{2,1,"6a"},{2,1,"6b"},{2,1,"6a"},{2,1,"6b"}},
        {{3,2,"7a"},{1,1,"7a"},{3,2,"7a"},{1,1,"7a"},{3,2,"7a"},{1,1,"7a"},{3,2,"7a"},{1,1,"7a"}},
        {{2,1,"7b"},{2,1,"7b"},{2,1,"7b"},{2,1,"7b"},{2,1,"7b"},{2,1,"7b"},{2,1,"7b"},{2,1,"7b"}},
        {{2,1,"6a"},{2,1,"6a"},{2,1,"6a"},{2,1,"6a"},{2,1,"6a"},{2,1,"6a"},{2,1,"6a"},{2,1,"6a"}},
        {{2,1,"6b"},{2,1,"6b"},{2,1,"6b"},{2,1,"6b"},{2,1,"6b"},{2,1,"6b"},{2,1,"6b"},{2,1,"6b"}}
	}


	--Stage 3 - Challenging Stage
    --Wave 1
    --    2x
    --        Bees x4 - "6a"
    --        Bees x4 - "6b"
    --Wave 2
    --    1x
    --        Boss x4 & Bees x4 - "7a"
    --Wave 3
    --    1x
    --        Bees x8 - "7b"
    --Wave 4
    --    1x
    --        Bees x8 - "6a"
    --Wave 5
    --    1x
    --        Bees x8 - "6b"
	
	paths={
		{{x=53,y=-3},{x=56,y=7},{x=61,y=16},{x=68,y=25},{x=78,y=33},{x=110,y=60},{x=113,y=70},{x=109,y=79},{x=97,y=81},{x=90,y=76},{x=85,y=66},{x=63,y=32}},
		{{x=127,y=114},{x=112,y=110},{x=95,y=101},{x=75,y=87},{x=68,y=75},{x=71,y=63},{x=82,y=60},{x=92,y=70},{x=88,y=83},{x=74,y=84},{x=69,y=66},{x=73,y=46}},
		{{x=0,y=114},{x=28,y=106},{x=46,y=95},{x=60,y=80},{x=62,y=69},{x=56,y=59},{x=44,y=57},{x=33,y=65},{x=31,y=77},{x=42,y=86},{x=58,y=84},{x=63,y=71},{x=63,y=44}},
		{{x=-3,y=106},{x=17,y=102},{x=28,y=99},{x=37,y=94},{x=45,y=88},{x=53,y=78},{x=55,y=69},{x=48,y=62},{x=38,y=66},{x=37,y=76},{x=45,y=81},{x=55,y=76},{x=55,y=44}},
		{{x=42,y=3},{x=50,y=11},{x=54,y=20},{x=62,y=31},{x=71,y=39},{x=104,y=64},{x=106,y=70},{x=102,y=74},{x=95,y=70},{x=89,y=63},{x=57,y=39}},
		{{x=69,y=2},{x=69,y=23},{x=67,y=45},{x=64,y=63},{x=57,y=81},{x=49,y=96},{x=35,y=106},{x=22,y=101},{x=17,y=90},{x=23,y=78},{x=38,y=71},{x=56,y=65},{x=120,y=43},{x=184,y=20}},
		{{x=0,y=114},{x=17,y=113},{x=30,y=111},{x=44,y=105},{x=61,y=95},{x=70,y=88},{x=76,y=77},{x=77,y=64},{x=76,y=49},{x=68,y=46},{x=64,y=55},{x=64,y=68},{x=65,y=77},{x=70,y=82},{x=140,y=70}}
	}

	--{{x=0,y=114},{x=28,y=106},{x=46,y=95},{x=60,y=80},{x=62,y=69},{x=56,y=59},{x=44,y=57},{x=33,y=65},{x=31,y=77},{x=42,y=86},{x=58,y=84},{x=63,y=71},{x=63,y=44}},
	--{{x=1,y=106},{x=17,y=102},{x=28,y=99},{x=37,y=94},{x=45,y=88},{x=53,y=78},{x=55,y=69},{x=48,y=62},{x=38,y=66},{x=37,y=76},{x=45,y=81},{x=55,y=76},{x=55,y=44}}

	-- Vars
	blink=0	
	firsttime=true
	maxfreelives=#freelifescores
	freelivesgiven=1
	stagetimer=0
	gamephase=0
	gameover=true
	player={x=63,y=112,lives=2,alive=true,t=0,f=1,animlock=1,score=0}
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
	jankymusictimer=0
	pausetimer=2
	stagekills=0
	bon=0

	initialisestars()
end

function _update60()

	musicstate=stat(24)

	if musicstate==3 then
		jankymusictimer+=0.1
		if jankymusictimer>5 then
			music(-1)
			jankymusictimer=0
		end
	end

	if (gamephase==2 or gamephase==3 or gamephase==4) and player.alive then
		controls()	
	else
		getshieldnumbers()	
		if btnp(🅾️) and gamephase==0 then
			gamephase=1
		end
	end

	----------------- game phase 1 -----------------
	if gamephase==1 then
		if musicstate < 0 then
			if gameover then
				--initialisestage()
				startgame()			
				--getshieldnumbers()	
				--gamephase=2		
			else 
				if stagetimer>0 then -- timer between stages. gives player a moment to prepare. -- and not stat(57)
					stagetimer-=0.1				
					
				else -- start next stage
					resetvars()
					initialisestage()
					getshieldnumbers() 
					gamephase=2
				end
			end
		end
	end
	
	----------------- game phase 2 -----------------
	if gamephase==2 then -- first wave attacks
		if nmewavenmes==0 then -- all wave enemies defeated. 
			if wavecounter==#nmewavequeue then	-- all waves completed. move to formation attack phase (game phase 3)
				if not ischallengingstage then
					if musicstate < 0 then				
						gamephase=3
					end
				else
					--do challenging stage stuff here
					if musicstate < 0 then
						music(5)	
						ischallengingstage=false
						bonusflag=true
					end
				end
			end
		else
			if not player.alive then -- player died during wave attack. move to game phase 5 (player respawn)
				gamephase=5
				stagetimer=9
				lastgamephase=2
			end
		end

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

	----------------- game phase 3 -----------------
	if gamephase==3 then
		if stagetimer>0 then -- formation attacks
			stagetimer-=0.1		
		else
			if #nmesatt==0  then
				if not nmealive and playfieldnmes<=0 then
					if player.alive  then -- all waves and formations cleared. move to next stage
						gamephase=4						
						stage+=1
						rounds={}
						nmerounds={}
						fire=0
						stagekills=0
						playfieldnmes=0
						if stage%3==0 then
							ischallengingstage=true
							nmewavespd=1.25
							stagetimer=15
							music(4)
						else
							ischallengingstage=false
							nmewavespd=1.75
							stagetimer=9
							sfx(5,3)
						end
						
					else
						gamephase=5
						stagetimer=9
					end
				else
					if not player.alive then -- player died during formation attack. move to game phase 5 (player respawn)
						gamephase=5
						stagetimer=8
					end
				end
			end
		end
	end

	----------------- game phase 4 -----------------
	if gamephase==4 then
		if stagetimer>0 then
			stagetimer-=0.1
			getshieldnumbers()
		else
			wavesetval+=1
			if wavesetval>3 then
				wavesetval=1
			end
			gamephase=1
		end
	end
	
	----------------- game phase 5 -----------------
	if gamephase==5 then
		if stagetimer>0 then
			stagetimer-=0.1
		else
			if #nmesatt==0 then			
				player.alive=true
				player.lives-=1
				player.x=63
				player.y=112
				gamephase=lastgamephase
			end
		end
	end
end
	
function _draw()
	cls(0)

	--for i=1,15 do
		--pal(i,i+128,1)
	--end
	
	dostarfield()

	--print("kills: " .. stagekills, 5,60,11)
	--print("nmewavenmes " .. tostr(nmewavenmes), 5,70,11)
	--print("playfieldnmes " .. tostr(playfieldnmes), 5,80,11)
	--if nmesatt~=nil then
	--	print("#nmesatt: " .. #nmesatt, 5,90,11)
	--end	
	--print("ischallengingstage: " .. tostr(ischallengingstage), 5,80,11)
	--print("gamephase: " .. tostr(gamephase), 5,90,11)
	--if nmewavequeue~=nil then
		--print("#nmewavequeue: " .. #nmewavequeue, 5,100,11)
	--end	
	--print("#nmewavequeue: " .. #nmewavequeue, 5,100,11)
	--print("wavecounter: " .. tostr(wavecounter), 5,110,11)
	--sprint("stage",35,25)
	
	if gamephase==0 then
		if firsttime then
			print("[press start to play]", 22,70,7)
		else
			print("game over", 45,63,7)
			print("[press start to play again]", 10,70,7)
		end		
	end		
	
	if gamephase==1 or gamephase==4 then
		if ischallengingstage then
			print("challenging stage",30,64,12) -- 68  (128-68)/2 = 60/2 = 30
		else
			print("stage " .. stage,50,64,12)
			--sprint("stage ",35,64,12)
		end		
	end

	if gamephase==2 and not ischallengingstage then

		if musicstate>=5 then
			print("number of hits ", 30,63,12)
		end

		if musicstate>=6 then
			if stagekills==40 then
				print("perfect !",46,49,8)
			end
			print(stagekills, 90,63,12)
		end
		
		if musicstate==7 then
			
			if bonusflag then
				if stagekills<40 then
					bon=(stagekills*10)
				else
					bon=500
				end				
				player.score+=(bon)
				bonusflag=false
			end
			if stagekills<40 then
				print("bonus " .. (bon), 44,77,12)
			else
				print("special bonus " .. (bon) .. " pts", 22,77,10)
			end
		end
	end

	if gamephase>=2 then	
		doenemy()
		dowave()

		if gamephase~=5 then
			doplayer()
		end
		doexplosions()
		animateplayerrounds(rounds,2,-1)
		animateenemyrounds(nmerounds,18,1) 
	end	
	
	if gamephase>1 or musicstate==2 or musicstate==3then
		setstageicons()
		setlivesicons()		
	end

	if musicstate==3 then
		spr(1,player.x,player.y)
	end
	
	-- Draw game border
	rect(0,0,127,127,7)
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
	
	if btnp(❎) and stagetimer<=0 then
		fire=1
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
	
	player={x=63,y=112,lives=2,alive=true,t=0,f=1,animlock=1,score=0}
	playerlifetimer=7
	gameover=false
	firsttime=false
	stagetimer=0 
	stage=1
end

function initialisestage()
	fire=0	
	rounds={}
	nmerounds={}	
	nmesatt={}	
	nmewave={}
	nmewavequeue={}
	explosions={}
	nmealive=true
	nmecount=40
	beginruntimer=0
	--freelivesgiven=1
	lastgamephase=2	
	playfield={}
	numshields={}	
	firesduringwave=0
	wavetimer=3
	wavecounter=1
	twave={}
	nmewavenmes=0
	respawndelay=5

	local nmex=12
	local nmey=4
	
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
	local nme={}
	for n=1,5 do
		local waveset={}
		for i=1,8 do
			if wavesetval==1 then		
				nme={x=0,y=0,ax=0,ay=0,lax=0,lay=0,f=1,st=0,dir=0,typ=wd1[n][i][1],t=1,ph=0,sw=flr(rnd(2)) * 2 - 1,col=0,row=0,mode=3,timer=3,dr=0.5,hp=wd1[n][i][2],path=wd1[n][i][3],index=1}	
			elseif wavesetval==2 then		
				nme={x=0,y=0,ax=0,ay=0,lax=0,lay=0,f=1,st=0,dir=0,typ=wd2[n][i][1],t=1,ph=0,sw=flr(rnd(2)) * 2 - 1,col=0,row=0,mode=3,timer=3,dr=0.5,hp=wd2[n][i][2],path=wd2[n][i][3],index=1}	
			else		
				nme={x=0,y=0,ax=0,ay=0,lax=0,lay=0,f=1,st=0,dir=0,typ=wd3[n][i][1],t=1,ph=0,sw=flr(rnd(2)) * 2 - 1,col=0,row=0,mode=3,timer=3,dr=0.5,hp=wd3[n][i][2],path=wd3[n][i][3],index=1}
			end
			add(waveset,nme)
		end
		if wavesetval==1 then	
			add(nmewavequeue, {wrv[n],waveset})
		elseif wavesetval==2 then	
			add(nmewavequeue, {wrv2[n],waveset})
		else
			add(nmewavequeue, {wrv[n],waveset})
		end
	end
	nmewavenmes=40
end

function resetvars() 
	fire=0	
	rounds={}
	nmerounds={}	
	nmesatt={}
	explosions={}
	nmecount=40
	beginruntimer=0
	playfield={}
	
end

function initialisestars()
	cols={5,2,1}
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
		spr(explosionsframes[flr(explosions[n].t)],explosions[n].x,explosions[n].y)
		explosions[n].t+=explosionspd
		if explosions[n].t>(6-explosionspd) then
			del(explosions,explosions[n])
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

function printpath(path) -- delete me
	for p in all(path) do
		print("x: " .. p.x .. " y: " .. p.y)
	end
end

function sprint(text,x,y)
	local strsize = #text
	local char=""
	local sprt=0
	local space=0

	for i=1,strsize do		
		char=sub(text,i,i)
		

		if font2[char]==nil then
			sprt=0
			space=0
		else
			sprt=font2[char]
			space=fontspaces2[sprt-227]
		end
		spr(sprt,x,y)
		x=x+8-space
	end
end
