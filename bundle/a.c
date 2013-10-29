float *samplv1_impl::paramPort ( samplv1::ParamIndex index )
{
        float *pfParam= 0;
 
        switch (index) {
        case samplv1::GEN1_SAMPLE:        pfParam = m_gen1.sample;      break;
        case samplv1::GEN1_LOOP:          pfParam = m_gen1.loop;        break;
        case samplv1::GEN1_OCTAVE:        pfParam = m_gen1.octave;      break;
        case samplv1::GEN1_TUNING:        pfParam = m_gen1.tuning;      break;
        case samplv1::GEN1_GLIDE:         pfParam = m_gen1.glide;       break;
        case samplv1::DCF1_CUTOFF:        pfParam = m_dcf1.cutoff;      break;
        case samplv1::DCF1_RESO:          pfParam = m_dcf1.reso;        break;
        case samplv1::DCF1_TYPE:          pfParam = m_dcf1.type;        break;
        case samplv1::DCF1_SLOPE:         pfParam = m_dcf1.slope;       break;
        case samplv1::DCF1_ENVELOPE:      pfParam = m_dcf1.envelope;    break;
        case samplv1::DCF1_ATTACK:        pfParam = m_dcf1.env.attack;  break;
        case samplv1::DCF1_DECAY:         pfParam = m_dcf1.env.decay;   break;
        case samplv1::DCF1_SUSTAIN:       pfParam = m_dcf1.env.sustain; break;
        case samplv1::DCF1_RELEASE:       pfParam = m_dcf1.env.release; break;
        case samplv1::LFO1_SHAPE:         pfParam = m_lfo1.shape;       break;
        case samplv1::LFO1_WIDTH:         pfParam = m_lfo1.width;       break;
        case samplv1::LFO1_RATE:          pfParam = m_lfo1.rate;        break;
        case samplv1::LFO1_SWEEP:         pfParam = m_lfo1.sweep;       break;
        case samplv1::LFO1_PITCH:         pfParam = m_lfo1.pitch;       break;
        case samplv1::LFO1_CUTOFF:        pfParam = m_lfo1.cutoff;      break;
        case samplv1::LFO1_RESO:          pfParam = m_lfo1.reso;        break;
        case samplv1::LFO1_PANNING:       pfParam = m_lfo1.panning;     break;
        case samplv1::LFO1_VOLUME:        pfParam = m_lfo1.volume;      break;
        case samplv1::LFO1_ATTACK:        pfParam = m_lfo1.env.attack;  break;
        case samplv1::LFO1_DECAY:         pfParam = m_lfo1.env.decay;   break;
        case samplv1::LFO1_SUSTAIN:       pfParam = m_lfo1.env.sustain; break;
        case samplv1::LFO1_RELEASE:       pfParam = m_lfo1.env.release; break;
        case samplv1::DCA1_VOLUME:        pfParam = m_dca1.volume;      break;
        case samplv1::DCA1_ATTACK:        pfParam = m_dca1.env.attack;  break;
        case samplv1::DCA1_DECAY:         pfParam = m_dca1.env.decay;   break;
        case samplv1::DCA1_SUSTAIN:       pfParam = m_dca1.env.sustain; break;
        case samplv1::DCA1_RELEASE:       pfParam = m_dca1.env.release; break;
        case samplv1::OUT1_WIDTH:         pfParam = m_out1.width;       break;
        case samplv1::OUT1_PANNING:       pfParam = m_out1.panning;     break;
        case samplv1::OUT1_VOLUME:        pfParam = m_out1.volume;      break;
        case samplv1::DEF1_PITCHBEND:     pfParam = m_def.pitchbend;    break;
        case samplv1::DEF1_MODWHEEL:      pfParam = m_def.modwheel;     break;
        case samplv1::DEF1_PRESSURE:      pfParam = m_def.pressure;     break;
        case samplv1::DEF1_VELOCITY:      pfParam = m_def.velocity;     break;
        case samplv1::DEF1_CHANNEL:       pfParam = m_def.channel;      break;
        case samplv1::DEF1_MONO:          pfParam = m_def.mono;         break;
        case samplv1::CHO1_WET:           pfParam = m_cho.wet;          break;
        case samplv1::CHO1_DELAY:         pfParam = m_cho.delay;        break;
        case samplv1::CHO1_FEEDB:         pfParam = m_cho.feedb;        break;
        case samplv1::CHO1_RATE:          pfParam = m_cho.rate;         break;
        case samplv1::CHO1_MOD:           pfParam = m_cho.mod;          break;
        case samplv1::FLA1_WET:           pfParam = m_fla.wet;          break;
        case samplv1::FLA1_DELAY:         pfParam = m_fla.delay;        break;
        case samplv1::FLA1_FEEDB:         pfParam = m_fla.feedb;        break;
        case samplv1::FLA1_DAFT:          pfParam = m_fla.daft;         break;
        case samplv1::PHA1_WET:           pfParam = m_pha.wet;          break;
        case samplv1::PHA1_RATE:          pfParam = m_pha.rate;         break;
        case samplv1::PHA1_FEEDB:         pfParam = m_pha.feedb;        break;
        case samplv1::PHA1_DEPTH:         pfParam = m_pha.depth;        break;
        case samplv1::PHA1_DAFT:          pfParam = m_pha.daft;         break;
        case samplv1::DEL1_WET:           pfParam = m_del.wet;          break;
        case samplv1::DEL1_DELAY:         pfParam = m_del.delay;        break;
        case samplv1::DEL1_FEEDB:         pfParam = m_del.feedb;        break;
        case samplv1::DEL1_BPM:           pfParam = m_del.bpm;          break;
        case samplv1::DYN1_COMPRESS:   pfParam = m_dyn.compress;     break;
        case samplv1::DYN1_LIMITER:     pfParam = m_dyn.limiter;      break;
        case samplv1::SCALE_TYPE:         pfParam = m_scl.type;         break;
        case samplv1::SCALE_NATURAL1_KEY: pfParam = m_scl.natural1_key; break;
        case samplv1::SCALE_CUSTOM_EDO:   pfParam = m_scl.custom_edo;   break;
        default: break;
        }
 
        return pfParam;
}
