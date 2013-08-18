unit drawSpace;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}
{$DEFINE CP_USE_DOUBLES}

interface

uses
  Chipmunk, math;

type
  PdrawSpaceOptions = ^drawSpaceOptions;
  drawSpaceOptions = record
    drawHash: Boolean;
    drawBBs: Boolean;
    drawShapes: Boolean;
    collisionPointSize: Single;
    bodyPointSize: Single;
    lineThickness: Single;
  end;

procedure draw(space: PcpSpace; options: PdrawSpaceOptions);

implementation

uses
  dglOpenGL;


const
  circleVar: array [0..51] of GLfloat = (
	 0.0000,  1.0000,
	 0.2588,  0.9659,
	 0.5000,  0.8660,
	 0.7071,  0.7071,
	 0.8660,  0.5000,
	 0.9659,  0.2588,
	 1.0000,  0.0000,
	 0.9659, -0.2588,
	 0.8660, -0.5000,
	 0.7071, -0.7071,
	 0.5000, -0.8660,
	 0.2588, -0.9659,
	 0.0000, -1.0000,
	-0.2588, -0.9659,
	-0.5000, -0.8660,
	-0.7071, -0.7071,
	-0.8660, -0.5000,
	-0.9659, -0.2588,
	-1.0000, -0.0000,
	-0.9659,  0.2588,
	-0.8660,  0.5000,
	-0.7071,  0.7071,
	-0.5000,  0.8660,
	-0.2588,  0.9659,
	 0.0000,  1.0000,
	 0.0, 0.0 // For an extra line to see the rotation.
  );
  circleVAR_count: Integer = sizeof(circleVAR) div sizeof(GLfloat) div 2;

  pillVAR: array [0..77] of GLfloat = (
  	 0.0000,  1.0000, 1.0,
  	 0.2588,  0.9659, 1.0,
  	 0.5000,  0.8660, 1.0,
  	 0.7071,  0.7071, 1.0,
  	 0.8660,  0.5000, 1.0,
  	 0.9659,  0.2588, 1.0,
  	 1.0000,  0.0000, 1.0,
  	 0.9659, -0.2588, 1.0,
  	 0.8660, -0.5000, 1.0,
  	 0.7071, -0.7071, 1.0,
  	 0.5000, -0.8660, 1.0,
  	 0.2588, -0.9659, 1.0,
  	 0.0000, -1.0000, 1.0,

  	 0.0000, -1.0000, 0.0,
  	-0.2588, -0.9659, 0.0,
  	-0.5000, -0.8660, 0.0,
  	-0.7071, -0.7071, 0.0,
  	-0.8660, -0.5000, 0.0,
  	-0.9659, -0.2588, 0.0,
  	-1.0000, -0.0000, 0.0,
  	-0.9659,  0.2588, 0.0,
  	-0.8660,  0.5000, 0.0,
  	-0.7071,  0.7071, 0.0,
  	-0.5000,  0.8660, 0.0,
  	-0.2588,  0.9659, 0.0,
  	 0.0000,  1.0000, 0.0
  );
  pillVAR_count: Integer = sizeof(pillVAR) div sizeof(GLfloat) div 3;

  springVAR: array [0..29] of GLfloat = (
  	0.00, 0.0,
  	0.20, 0.0,
  	0.25, 3.0,
  	0.30,-6.0,
  	0.35, 6.0,
  	0.40,-6.0,
  	0.45, 6.0,
  	0.50,-6.0,
  	0.55, 6.0,
  	0.60,-6.0,
  	0.65, 6.0,
  	0.70,-3.0,
  	0.75, 6.0,
  	0.80, 0.0,
  	1.00, 0.0
  );
  springVAR_count: Integer = sizeof(springVAR) div sizeof(GLfloat) div 2;

procedure glColor_from_pointer(ptr: Pointer);
const
  mult = 127;
  add = 63;
var
  val: Cardinal;
  r, g, b: GLubyte;
  max: GLubyte;
  v: GLfloat;
begin
  val := Cardinal(ptr);

  // hash the pointer up nicely
	val := (val  +  $7ed55d16)  +  (val shl 12);
	val := (val xor $c761c23c) xor (val shr 19);
	val := (val  +  $165667b1)  +  (val shl  5);
	val := (val  +  $d3a2646c) xor (val shl  9);
	val := (val  +  $fd7046c5)  +  (val shl  3);
	val := (val xor $b55a4f09) xor (val shr 16);

  //v := val/MaxUIntValue;
 	//v := 0.95 - v * 0.15;
  //
  //glColor3f(v, v, v);

  r := (val shr 0) and $FF;
  g := (val shr 8) and $FF;
  b := (val shr 16) and $FF;

  if r > g then
  begin
    if r > b then
      max := r
    else
      max := b
  end
  else
  begin
    if g > b then
      max := g
    else
      max := b
  end;

  r := (r * mult) div max + add;
  g := (g * mult) div max + add;
  b := (b * mult) div max + add;

  glColor3ub(r, g, b);
end;

procedure glColor_for_shape(shape: PcpShape; space: PcpSpace);
var
  body: PcpBody;
  v: GLfloat;
begin
  body := shape.body;
  if Assigned(body) then
  begin
    if Assigned(body.node.next) then
    begin
      v := 0.25;
      glColor3f(v, v, v);
      Exit;
    end
    else if (body.node.idleTime > space.sleepTimeThreshold) then
    begin
      v := 0.9;
      glColor3f(v, v, v);
      Exit;
    end;
  end;

  glColor_from_pointer(shape);
end;

procedure drawCircleShape(body: PcpBody; circle: PcpCircleShape; space: PcpSpace);
var
  center: cpVect;
begin
  glVertexPointer(2, GL_FLOAT, 0, @circleVar);

  glPushMatrix();
  begin
    center := circle.tc;
    glTranslatef(center.x, center.y, 0.0);
    glRotatef(body.a * 180.0 / pi, 0.0, 0.0, 1.0);
    glScalef(circle.r, circle.r, 1.0);

    if not (circle.shape.sensor) then
    begin
      glColor_for_shape(PcpShape(circle), space);
      glDrawArrays(GL_TRIANGLE_FAN, 0, circleVAR_count - 1);
    end;

    glColor3f(0.0, 0.0, 0.0);
  end;
  glPopMatrix();
end;

procedure drawSegmentShape(body: PcpBody; seg: PcpSegmentShape; space: PcpSpace);
var
  a, b, d, r: cpVect;
  matrix: array [0..15] of GLfloat;
begin
  a := seg.ta;
  b := seg.tb;

  if seg.r <> 0 then
  begin
    glVertexPointer(3, GL_FLOAT, 0, @pillVAR);
    glPushMatrix();
    begin
      d := cpvsub(b, a);
      r := cpvmult(d, seg.r / cpvlength(d));
      FillChar(matrix, SizeOf(matrix), 0);
      matrix[0] := r.x;
      matrix[1] := r.y;
      matrix[4] := -r.y;
      matrix[5] := r.x;
      matrix[8] := d.x;
      matrix[9] := d.y;
      matrix[12] := a.x;
      matrix[13] := a.y;
      matrix[15] := 1.0;
      glMultMatrixf(@matrix);

      if not seg.shape.sensor then
      begin
        glColor_for_shape(PcpShape(seg), space);
        glDrawArrays(GL_TRIANGLE_FAN, 0, pillVAR_count);
      end;

      glColor3f(0.0, 0.0, 0.0);
      glDrawArrays(GL_LINE_LOOP, 0, pillVAR_count);
    end;
    glPopMatrix();
  end
  else
  begin
    glColor3f(0.0, 0.0, 0.0);
    glBegin(GL_LINES);
      glVertex2f(a.x, a.y);
      glVertex2f(b.x, b.y);
    glEnd();
  end;
end;

procedure drawPolyShape(body: PcpBody; poly: PcpPolyShape; space: PcpSpace);
var
  count: Integer;
begin
  count := poly.numVerts;
{$IFDEF CP_USE_DOUBLES}
  glVertexPointer(2, GL_DOUBLE, 0, poly.tVerts);
{$ELSE}
  glVertexPointer(2, GL_FLOAT, 0, poly.tVerts);
{$ENDIF}

  if not (poly.shape.sensor) then
  begin
    glColor_for_shape(PcpShape(poly), space);
    glDrawArrays(GL_TRIANGLE_FAN, 0, count);
  end;

  glColor3f(0.0, 0.0, 0.0);
  glDrawArrays(GL_LINE_LOOP, 0, count);
end;

procedure drawObject(shape: Pointer; space: Pointer); cdecl;
var
  body: PcpBody;
begin
  body := PcpShape(shape).body;

  case PcpShape(shape).klass._type of
    CP_CIRCLE_SHAPE:
      drawCircleShape(body, PcpCircleShape(shape), space);
    CP_SEGMENT_SHAPE:
      drawSegmentShape(body, PcpSegmentShape(shape), space);
    CP_POLY_SHAPE:
      drawPolyShape(body, PcpPolyShape(shape), space);
    else
      WriteLn('Bad enumeration in drawObject().');
  end;
end;

procedure drawSpring();
begin

end;

procedure drawConstraint(constraint: PcpConstraint);
begin

end;

procedure drawBB(shape: Pointer; unused: Pointer); cdecl;
var
  sh: PcpShape;
begin
  sh := PcpShape(shape);
	glBegin(GL_LINE_LOOP);
		glVertex2f(sh.bb.l, sh.bb.b);
		glVertex2f(sh.bb.l, sh.bb.t);
		glVertex2f(sh.bb.r, sh.bb.t);
		glVertex2f(sh.bb.r, sh.bb.b);
	glEnd();
end;

// copied from cpSpaceHash.c
function hash_func(x, y, n: cpHashValue): cpHashValue; inline;
begin
  Result := (x * 1640531513 xor y * 2654435789) mod n;
end;

procedure drawSpatialHash(hash: PcpSpaceHash);
begin

end;

procedure draw(space: PcpSpace; options: PdrawSpaceOptions);
var
  constraints: PcpArray;
  bodies: PcpArray;
  body: PcpBody;
  i, j: Integer;
  arbiters: PcpArray;
  arb: PcpArbiter;
  v: cpVect;
begin
  if options.drawHash then
  begin
    glColorMask(false, true, false, true);
    drawSpatialHash(space.activeShapes);
		glColorMask(true, false, false, false);
		drawSpatialHash(space.staticShapes);
		glColorMask(true, true, true, true);
  end;

  glLineWidth(options.lineThickness);
{  if options.drawShapes then
  begin
    cpSpaceHashEach(space.activeShapes, drawObject, space);
		cpSpaceHashEach(space.staticShapes, drawObject, space);
  end;}

  glLineWidth(1.0);
  if options.drawBBs then
  begin
		glColor3f(0.3, 0.5, 0.3);
		cpSpaceHashEach(space.activeShapes, drawBB, nil);
		cpSpaceHashEach(space.staticShapes, drawBB, Nil);
  end;

  constraints := space.constraints;

  glColor3f(0.5, 1.0, 0.5);
  for i := 0 to constraints.num - 1 do
    drawConstraint(PcpConstraint(PChar(constraints.arr) + i));

  if (options.bodyPointSize <> 0) then
  begin
    glPointSize(options.bodyPointSize);

    glBegin(GL_POINTS);
      glColor3f(0.0, 0.0, 0.0);
      bodies := space.bodies;
      for i := 0 to bodies.num - 1 do
      begin
//        body := PcpBody(bodies.arr + i);
//        glVertex2f(body.p.x, body.p.y);
      end;

//		glColor3f(0.5f, 0.5f, 0.5f);
//		cpArray *components = space->components;
//		for(int i=0; i<components->num; i++){
//			cpBody *root = components->arr[i];
//			cpBody *body = root, *next;
//			do {
//				next = body->node.next;
//				glVertex2f(body->p.x, body->p.y);
//			} while((body = next) != root);
//		}
    glEnd();
  end;

  {
  if options.collisionPointSize <> 0 then
  begin
    glPointSize(options.collisionPointSize);
    glBegin(GL_POINTS);
      arbiters := space.arbiters;
      for i := 0 to arbiters.num - 1 do
      begin
        arb := PcpArbiter(arbiters.arr + i);

        glColor3f(1.0, 0.0, 0.0);
        for j := 0 to arb.numContacts - 1 do
        begin
          v := arb.contacts[j].p;
          glVertex2f(v.x, v.y);
        end;
      end;
    glEnd();
  end;
  }
end;

end.

