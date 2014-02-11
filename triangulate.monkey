' triangulate.monkey

' v0.4 - fat ears optimisation 
' v0.3 - fixed inside tri test 

Function DotProduct#(x0#,y0#,x1#,y1#,x2#,y2#)
	Return (x1-x0)*(y2-y1)-(x2-x1)*(y1-y0)
End Function

Function InsideTriangle?(px#,py#,x0#,y0#,x1#,y1#,x2#,y2#)
	If DotProduct(x0,y0,x1,y1,px,py)<0
		If DotProduct(x1,y1,x2,y2,px,py)<0
			If DotProduct(x2,y2,x0,y0,px,py)<0
				Return True
			Endif
		Endif
	Endif
End

' returns list of float arrays that can each be passed to DrawPolygon

Function Triangulate:List<Float[]>(poly:Float[])

	Local xy#[]=poly.Resize(poly.Length)

	Local list:=New List<Float[]>

	Local n=xy.Length/2
	
	Local count=n-2

	Local a=0
	Local b=1
	Local c=2
	
	Local miss=0
	
	Local ear:=New Stack<Float>
		
	While count>0 And miss<20
					
		Local x0#=xy[a*2+0]
		Local y0#=xy[a*2+1]
		Local x1#=xy[b*2+0]
		Local y1#=xy[b*2+1]
		Local x2#=xy[c*2+0]
		Local y2#=xy[c*2+1]
		
		Local ok?=False
		
		If DotProduct(x0,y0,x1,y1,x2,y2)<0
			ok=True						
			Local t=c+1
			If t=n t=0
			While t<>a				
				Local px#=xy[t*2+0]
				Local py#=xy[t*2+1]				
				If InsideTriangle(px,py,x0,y0,x1,y1,x2,y2)				
					ok=False
					Exit
				Endif				
				t+=1
				If t=n t=0		
			Wend			
			
		Endif
			
		If  ok		
			If ear.IsEmpty				
				ear.Push x0
				ear.Push y0
				ear.Push x1
				ear.Push y1
			Endif
			ear.Push x2
			ear.Push y2
													
			miss=0
			count-=1
			n-=1
			
			For Local i=b Until n
				xy[i*2+0]=xy[i*2+2]
				xy[i*2+1]=xy[i*2+3]
			Next
			
			If a>b a-=1
			If c>b c-=1
						
			b=c
			c=c+1

			If c>=n c-=n
					
			Continue			
		Else			
			If Not ear.IsEmpty
				list.AddLast ear.ToArray
				ear.Clear
			Endif			
		Endif
				
		a=b
		b=c
		c=c+1
		If c>=n c-=n		
		miss+=1
	
	Wend
		
	If Not ear.IsEmpty
		list.AddLast ear.ToArray
		ear.Clear
	Endif			

	Return list
End