class Scale{

    int note[];
    fun void set(int p,string mode)
    
    {
        
        if(mode=="ionian" || mode=="i")
            
            [p,p+2,p+4,p+5,p+7,p+9,p+11]@=>note;
        
        else if(mode=="d||ian" || mode=="ii")
            
            [p,p+2,p+3,p+5,p+7,p+8,p+10]@=>note;
        
        else if(mode=="phrygian" || mode=="iii")
            
            [p,p+1,p+3,p+5,p+7,p+8,p+10]@=>note;
        
        else if(mode=="lydian" || mode=="iv")
            
            [p,p+2,p+4,p+6,p+7,p+9,p+11]@=>note;
        
        else if(mode=="mixolydian" || mode =="v")
            
            [p,p+2,p+4,p+5,p+7,p+9,p+10]@=>note;
        
        else if(mode=="aeolian" || mode=="vi")
            
            [p,p+2,p+3,p+5,p+7,p+8,p+10]@=>note;
        
        else if(mode=="locrian" || mode=="vii")
            
            [p,p+1,p+3,p+5,p+7,p+8,p+10]@=>note;
        
        else
            
            [p,p+2,p+4,p+5,p+7,p+9,p+11]@=>note;
        
    }
    
    
    
    fun int sample()
    
    {
        
        note.cap()=>int len;
        
        return note[Math.random2(0,len-1)];
        
    }
    
    

    
    
}





 class Chord

{
    
    int note[];
    
    
    fun void set(int root, string quality)
    
    {
        
        if(quality=="major")
            
            [root,root+4,root+7]@=>note;
        
        else if(quality=="minor")
            
            [root,root+3,root+7]@=>note;
        
        else if(quality=="major7")
            
            [root,root+4,root+7,root+11]@=>note;
        
        else if(quality=="dom7")
            
            [root,root+4,root+7,root+10]@=>note;
        
        else if(quality=="minor7")
            
            [root,root+3,root+7,root+10]@=>note;
        
        else if(quality=="mMaj7")
            
            [root,root+3,root+7,root+11]@=>note;
        
    }
    
    
    
    fun int sample()
    
    {
        
        note.cap()=>int len;
        
        return note[Math.random2(0,len-1)];
        
    }
    
    
    fun int get(int i)
    {
        
        return note[i];
    }
    
    
}


0.5=>dac.gain;

ADSR env => JCRev rev =>  dac;
0.3=>rev.mix;

env.set(1::ms,30::ms,.5,100::ms);

SinOsc s[4];
Pan2 pan[4];
for(0=>int i;i<3;i++)
{
    s[i]=>pan[i]=>env;
    1.0=>s[i].gain;
}

-0.3=>pan[0].pan;
0.3=>pan[2].pan;
-1.0=>pan[1].pan;
1.0=>pan[3].pan;


SawOsc s0=> ADSR env0=>JCRev rev0=>dac;
0.02=>rev0.mix;
env0.set(80::ms,50::ms,.9,400::ms);

60=>int root;
Chord chord;

Scale scale;
scale.set(root,"i");


fun void setChord(int root,string quality)
{
    chord.set(root,quality);
    for(0=>int i;i<chord.note.cap();i++)
    {
        chord.get(i)=>Std.mtof=>s[i].freq;
    }

}

fun void play()
{
    
    1=>env.keyOn;
    100::ms=>now;
    1=>env.keyOff;
    150::ms=>now; 
}

fun void playMelody()
{
    
    
    
    now+15::second=>time future;
    0.3=>s0.gain;
    0.7=>s0.width;
    while(now<future)
    {
        chord.get(0)-12=>Std.mtof=>s0.freq;
        1=>env0.keyOn;
        100::ms=>now;
        1=>env.keyOff;
        150::ms=>now;
    }
    
    0.9=>s0.width;
    0.6=>s0.gain;
    now+1::second=>future;
    while(now<future)
    {
   
            
        scale.sample()+Math.random2(0,2)*12=>Std.mtof=>s0.freq;
        1=>env0.keyOn;
        12.5::ms=>now;
        1=>env.keyOff;
    }
    
    0.5=>s0.width;
    1.0=>s0.gain;
    while(true)
    {
        Math.random2(0,1) => int dice;
        if(dice==0)
        {
            1=>env0.keyOn;
            chord.sample()+Math.random2(0,0)*12=>Std.mtof=>s0.freq;
            100::ms=>now;
            1=>env0.keyOff;
            25::ms=>now;
        }
        else if(dice==1)
        {
            125::ms=>now;
        }

    }   
}

spork ~playMelody();

while(true)
{
    
    setChord(root,"major7");
    repeat(8)
    {
        play();
    }
    setChord(root-5,"dom7");
    repeat(8)
    {
        play();
    }
    setChord(root-3,"minor7");
    repeat(8)
    {
        play();
    }
    setChord(root-8,"minor7");
    repeat(8)
    {
        play();
    }  
    setChord(root+5,"major7");
    repeat(8)
    {
        play();
    }  
    setChord(root,"major7");
    repeat(8)
    {
        play();
    }  
    setChord(root+5,"major7");
    repeat(8)
    {
        play();
    }  
    setChord(root+7,"dom7");
    repeat(8)
    {
        play();
    }  
}












