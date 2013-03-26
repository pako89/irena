#ifndef _DCT_H
#define _DCT_H

#include <utils.h>
#include <transform.h>

namespace avlib
{

class CDCT 
{
public:
	CDCT();
	virtual ~CDCT();
	virtual void Transform(CImage<float> * src, CImage<float> * dst);
	virtual void Transform8x8(float * pSrc, float * pDst, int width);
	virtual void Transform8(float * pSrc, int srcStep, float * pDst, int dstStep);
protected:
	static const float s1;
	static const float s2;
	static const float s3;
	static const float c1;
	static const float c2;
	static const float c3;
	static const float c4;
};

class CIDCT
{
public:
	CIDCT();
	virtual ~CIDCT();
	virtual void Transform(CImage<float> * src, CImage<float> * dst);
	virtual void Transform8x8(float * pSrc, float * pDst, int width);
	virtual void Transform8(float * pSrc, int srcStep, float * pDst, int dstStep);
protected:
	static const float c1;
	static const float c2;
	static const float c3;
	static const float c4;
	static const float c5;
	static const float c6;
	static const float cn;
	
};

}


#endif //_DCT_H
