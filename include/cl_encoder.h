#ifndef _CL_ENCODER_H
#define _CL_ENCODER_H

#include <basic_encoder.h>

#include <cl_device.h>
#include <cl_image.h>
#include <cl_dct.h>
#include <cl_quantizer.h>
#include <cl_zigzag.h>
#include <cl_base.h>
#include <cl_policy.h>
#include <CL/opencl.h>
#include <fstream>
#include <string>
#include <mtimer.h>

namespace avlib
{

class CCLEncoder : public CBasicEncoder
{
public:
	CCLEncoder();
	CCLEncoder(EncoderConfig cfg);
	virtual ~CCLEncoder();
	virtual bool Encode(CSequence * pSeq, CBitstream * pBstr);
protected:
	virtual void init(CImageFormat fmt);
	std::string get_src_from_file(char * file_name);
	CCLDevice m_dev;
	cl_program m_program;
	CCLDevicePolicy * m_clPolicy;
	utils::CTimer m_timerCopyToDevice;
	utils::CTimer m_timerCopyToHost;
};

}

#endif //_CL_ENCODER