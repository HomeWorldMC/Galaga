-- Formation rounds check
if doboxcollision(playfield[r][c].nme.x,playfield[r][c].nme.y,rds.x,rds.y,nmehitboxwidth) and not disableplayer and not playfield[r][c].nme.isimmortal then
	
	if playfield[r][c].nme.hp>1 then
		playfield[r][c].nme.hp-=1
	else
		sfx(1,1) -- nme explode sound
		player.score+=nmescores[playfield[r][c].nme.typ]
		add(explosions,{x=playfield[r][c].nme.x,y=playfield[r][c].nme.y,t=1})
		del(rounds,rds)
		freelifecheck()
		stagekills+=1

		playfield[r][c].nme.mode=2
		playfield[r][c].canwrite=true	
		playfieldnmes-=1
	end
end

-- attack swoops rounds check
if doboxcollision(nmeatt.ax,nmeatt.ay,r.x,r.y,nmehitboxwidth) and not disableplayer and not nmeatt.isimmortal then
	if nmeatt.hp>1 then
		nmeatt.hp-=1
	else
		sfx(1,1) -- nme explode sound
		player.score+=(nmescores[nme.typ]*bonus)
		add(explosions,{x=nmeatt.ax,y=nmeatt.ay,t=1})
		del(nmesatt,nmeatt)
		freelifecheck()
		stagekills+=1
	end
	del(rounds,r)
end

-- Capture run rounds check
if doboxcollision(nme.x,nme.y,r.x,r.y,nmehitboxwidth) and not disableplayer and not nme.isimmortal then	
	del(rounds,r)
	if nme.hp>1 then
		nme.hp-=1
	else
		sfx(1,1) -- nme explode sound
		player.score+=(nmescores[nme.typ]*4)
		add(explosions,{x=nme.x,y=nme.y,t=1})			
		del(twave,nme)
		freelifecheck()	
		stagekills+=1

		nmewavenmes-=1
		nme.mode=2		
		if nme.row>0 and nme.col>0 then
			playfield[nme.row][nme.col].holdslot=false	
		end

		
	end
end

function checkrounds(nme,nmetable,r, bonus)
	if doboxcollision(nme.x,nme.y,r.x,r.y,nmehitboxwidth) and not disableplayer and not nme.isimmortal then	
		if nme.hp>1 then
			nme.hp-=1
		else
			sfx(1,1) -- nme explode sound
			player.score+=(nmescores[nme.typ]*bonus)
			add(explosions,{x=nme.x,y=nme.y,t=1})
			del(nmetable,nme)
			freelifecheck()
			stagekills+=1

			--special conditions
			
			---- Formation attacks
			playfield[r][c].nme.mode=2
			playfield[r][c].canwrite=true	
			playfieldnmes-=1

			---- Attacking
			-- none

			---- Capturing
			nmewavenmes-=1
			nme.mode=2		
			if nme.row>0 and nme.col>0 then
				playfield[nme.row][nme.col].holdslot=false	
			end

		end
	end
	
end