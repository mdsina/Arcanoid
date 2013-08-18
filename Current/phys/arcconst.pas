unit arcconst;

interface

uses sdl;

const
  TGA_FILE = 1;
  BMP_FILE = 2;

  AUDIO_FREQUENCY : Integer = 22050;
  AUDIO_FORMAT 	: Word 	  = AUDIO_S16;
  AUDIO_CHANNELS 	: Integer = 2;
  AUDIO_CHUNKSIZE : Integer = 4096;
  FXAA_PC : Integer = 1;
  FXAA_GLSL_130 : Integer= 1;
  FXAA_QUALITY__PRESET: Integer =  13;

 implementation
 end.
