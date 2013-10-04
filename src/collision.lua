local collision = {}


function collision.seg(a1x,a1y,a2x,a2y,b1x,b1y,b2x,b2y)
	local inter=((b2y-b1y)*(a2x-a1x))-((b2x-b1x)*(a2y-a1y))
	if inter~=0 then
		return true;
	end
	--[[if inter ==0 then
		return {}
	else
		ua=(((b2x-b1x)*(a1y-b1y))-((b2y-b1y)*(a1x-b1x)))/inter
		ub=(((a2x-a1x)*(a1y-b1y))-((a2y-a1y)*(a1x-b1x)))/inter
		if (ua<0 or ua>1 or ub<0 or ub>1) then
			return {{a1x+ua*(a2x-a1x),a2y+ua*(a2y-a1y)}}
		end
	end
	--]]
end
a= collision.seg(1,1,3,3,1,1,3,3)
for i,v in pairs(a) do
print(v[1],v[2])
end

function collision.segRect(ax,ay,ah,aw,ar,s1x,s1y,s2x,s2y)
	if(ar%math.pi==0) then
		local a,d = useful.cartesianToPolar(-aw/2,ah/2)
		local x1t,y1t=useful.polarToCartesian(ar+a,d)
		local x2t,y2t=useful.polarToCartesian(ar+a+math.pi,d)
		local x1=ax+x1t
		local y1=ay+y1t
		local x2=ax+x2t
		local y2=ay+y2t
		local a,d = useful.cartesianToPolar(aw/2,ah/2)
		local x3t,y3t=useful.polarToCartesian(ar+a,d)
		local x4t,y4t=useful.polarToCartesian(ar+a+math.pi,d)
		local x3=ax+x3t
		local y3=ay+y3t
		local x4=ax+x4t
		local y4=ay+y4t
	else
		local x1=ax-aw/2
		local y1=ay+ah/2
		local x2=ax+aw/2
		local y2=ay+ah/2
		local x3=ax+aw/2
		local y3=ay-ah/2
		local x4=ax-aw/2
		local y4=ay-ah/2
	end
	if(collision.seg(x1,y1,x2,y2,s1x,s1y,s2x,s2y)) then
		return true
	end
	if(collision.seg(x2,y2,x3,y3,s1x,s1y,s2x,s2y)) then
		return true
	end
	if(collision.seg(x3,y3,x4,y4,s1x,s1y,s2x,s2y)) then
		return true
	end
	if(collision.seg(x1,y1,x4,y4,s1x,s1y,s2x,s2y)) then
		return true
	end
	return false

end

function collision.recRec(ax,ay,ah,aw,ar,bx,by,bh,bw,br)
	if(ar%math.pi==0) then
		local a,d = useful.cartesianToPolar(-aw/2,ah/2)
		local x1t,y1t=useful.polarToCartesian(ar+a,d)
		local x2t,y2t=useful.polarToCartesian(ar+a+math.pi,d)
		local x1=ax+x1t
		local y1=ay+y1t
		local x2=ax+x2t
		local y2=ay+y2t
		local a,d = useful.cartesianToPolar(aw/2,ah/2)
		local x3t,y3t=useful.polarToCartesian(ar+a,d)
		local x4t,y4t=useful.polarToCartesian(ar+a+math.pi,d)
		local x3=ax+x3t
		local y3=ay+y3t
		local x4=ax+x4t
		local y4=ay+y4t
	else
		local x1=ax-aw/2
		local y1=ay+ah/2
		local x2=ax+aw/2
		local y2=ay+ah/2
		local x3=ax+aw/2
		local y3=ay-ah/2
		local x4=ax-aw/2
		local y4=ay-ah/2
	end
	if(collision.segRect(bx,by,bh,bw,br,x1,y1,x2,y2))then
		return true
	end
	
	if(collision.segRect(bx,by,bh,bw,br,x2,y2,x3,y3))then
		return true
	end
	
	if(collision.segRect(bx,by,bh,bw,br,x3,y3,x4,y4))then
		return true
	end
	
	if(collision.segRect(bx,by,bh,bw,br,x1,y1,x4,y4))then
		return true
	end

	return false

end

function collision.AABB(ax,ay,aw,ah, bx,by,bw,bh)
	local ah = ah/2
	local aw = aw/2
	local bh = bh/2
	local bw = bw/2
	return not (
		ay+ah<by-bh or
		ay-ah>by+bh or
		ax-aw>bx+bw or
		ax+aw<bx-bh)
end


function collision.pointRec(ax,ay,bx,by,bw,bh,br)
	local ax,ay = ax,ay
	if br%math.pi~=0 then
		local a,d = useful.cartesianToPolar(ax-bx,ay-by)
		local nx,ny = useful.polarToCartesian(a+br,d)
		ax = bx+nx
		ay = by+ny
	end
	return 
end

--[[]
for i=1,10 do
	collision.pointRec(math.random(-100,100),math.random(-100,100),math.random(-100,100),math.random(-100,100),math.random(-100,100),math.random(-100,100),math.random()*math.pi*2)
end

--]]

return collision