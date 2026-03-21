function firelaser()
	add(rounds,{x=player.x+4,y=player.y})
	fire=0
	sfx(0,2) --player laser sound
end

function animateplayerrounds(rnds,sp,dir)
	for i in all(rnds) do
		--spr(sp,i.x-1,i.y-5)
		queue_spr(sp,i.x-1,i.y-5)
		pset(i.x-1,i.y-5,11)
		i.y+= 3*dir
		if i.y < 4 or i.y>132 then
			del(rnds,i)
		end
		
	end
	
	--debug1=print("nmerounds:" .. #nmerounds,10,64)
end

function animateenemyrounds(rnds,sp,dir)
	for i in all(rnds) do
		i.x += i.vx
		i.y += i.vy
		
		if i.x < 0 or i.x > 128 or i.y>132 or i.y<0 then
			del(rnds,i)
		end
		queue_spr(sp,i.x-1,i.y-5)
		--spr(sp,i.x-1,i.y-5)
	end
end