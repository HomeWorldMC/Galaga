function firelaser()
	for i=0, player.p-1 do
		add(rounds,{x=player.x+xo[player.p+i],y=player.y})
	end
	sfx(0,2)
end

function animateplayerrounds(rnds,sp,dir)
	for i in all(rnds) do
		queue_spr(sp,i.x-1,i.y-5,1,1,false,false)
		pset(i.x-1,i.y-5,11)
		i.y+= 3*dir
		if i.y < 4 or i.y>132 then
			del(rnds,i)
		end		
	end
end

function animateenemyrounds(rnds,sp,dir)
	for i in all(rnds) do
		i.x += i.vx
		i.y += i.vy

		queue_spr(sp,i.x-1,i.y-5,1,1,false,false)
		if i.x < 0 or i.x > 128 or i.y>132 or i.y<0 then
			del(rnds,i)
		end
	end
end