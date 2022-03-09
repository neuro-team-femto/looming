scenario = "Own_name";
pulse_width = 2; 
write_codes = true;
active_buttons = 1;
response_matching = simple_matching;
default_attenuation = 0;
default_font_size = 24;

begin;

# DEFINE SOUNDS
sound { wavefile { filename = "standard.wav"; }; default_code = "std";} STD; #code 1
sound { wavefile { filename = "standard.wav"; }; default_code = "0";} STD_OFF; #code 2
sound { wavefile { filename = "deviant_flat.wav"; }; default_code = "deviant_flat"; } DEV_FLAT; # code 3
sound { wavefile { filename = "deviant_smile.wav"; }; default_code = "deviant_smile"; } DEV_SMILE; # code 4
sound { wavefile { filename = "deviant_rough.wav"; }; default_code = "deviant_rough"; } DEV_ROUGH; # code 5
sound { wavefile { filename = "deviant_rise.wav"; }; default_code = "deviant_rise"; } DEV_RISE; # code 6
sound { wavefile { filename = "deviant_fall.wav"; }; default_code = "deviant_fall"; } DEV_FALL; # code 7
	
# DEFINE TRIALS
trial {
	trial_type = specific_response;
	terminator_button = 1;
	trial_duration = forever;
	picture{
		text { 
			caption = "Instructions";
		} instruct_text;
		x = 0; 
		y = 0;
	} instruct_pic;
} instruct_trial;

trial {
	start_delay = 600; 
	stimulus_event {sound STD; port = 1; port_code = 1;};
} main_trial;

trial {		
	start_delay =600;
	stimulus_event {sound DEV_FLAT; port = 1; port_code = 3;};	
	stimulus_event {sound STD_OFF; deltat = 1200; port = 1; port_code = 2;};
} dev_flat_trial;

trial {		
	start_delay =600;
	stimulus_event {sound DEV_SMILE; port = 1; port_code = 4;};	
	stimulus_event {sound STD_OFF; deltat = 1200; port = 1; port_code = 2;};
} dev_smile_trial;
	
trial {		
	start_delay =600;
	stimulus_event {sound DEV_ROUGH; port = 1; port_code = 5;};	
	stimulus_event {sound STD_OFF; deltat = 1200; port = 1; port_code = 2;};
} dev_rough_trial;
	
trial {		
	start_delay = 600;
	stimulus_event {sound DEV_RISE; port = 1; port_code = 6;};	
	stimulus_event {sound STD_OFF; deltat = 1200; port = 1; port_code = 2;};
} dev_rise_trial;
	
trial {		
	start_delay =600;
	stimulus_event {sound DEV_FALL; port = 1; port_code = 7;};	
	stimulus_event {sound STD_OFF; deltat = 1200; port = 1; port_code = 2;};
} dev_fall_trial;
	
picture {
	text{ caption = "+"; };
	x = 0;
	y = 0;} default;
 	
begin_pcl;

# -------------------------------------
# CONSTRUCT TRIAL SEQUENCE

int num_trials = 1200; 
int num_actual_trials = 960;
int num_dev = 80; # times 3 types of deviants
int num_start_trials = 10;
int num_std = 960 - 3*num_dev - num_start_trials;

#num_trials = 50;
#num_actual_trials = 40;
#num_dev = 5; # times 3 types of deviants
#num_start_trials = 10;
#num_std = 40 - 3*num_dev - num_start_trials;


array<trial> trial_seq[0];
# add initial standards
loop int i = 1 until i== num_start_trials
begin
	trial_seq.add(main_trial);
	i = i + 1;
end;	
# add rem_standards trials
loop int i = 1 until i== num_std
begin
	trial_seq.add(main_trial);
	i = i + 1;
end;	
# add deviants trials
loop int i = 1 until i== num_dev
begin
	trial_seq.add(dev_flat_trial);
	trial_seq.add(dev_smile_trial);
	trial_seq.add(dev_rough_trial);
	i = i + 1;	
end;
# shuffle after initial trials
trial_seq.shuffle(num_start_trials+1,trial_seq.count());
	
instruct_text.set_caption("Dans cette expérience, vous allez entendre un grand nombre de sons: des bips et, parfois, votre prénom, prononcé de différentes façons.\n\n Nous vous demandons de garder vos yeux ouverts et fixés sur la croix au centre de l'écran, \n et de compter dans votre tête le nombre de fois où vous entendez votre prénom,\n quelque soit la façon dont il est prononcé.\n\n Appuyez sur espace pour commencer"); 
instruct_text.redraw();
instruct_trial.present();

# -------------------------------
# PLAY SEQUENCE
loop int i = 1 until i > trial_seq.count()
begin
			# edit current trial with jitter
			trial_seq[i].set_start_delay(random(500,700));
			# present trial
			trial_seq[i].present();
			i = i + 1;
end;

instruct_text.set_caption("Cette partie de l'expérience est terminée. Appuyez sur espace pour commencer"); 
instruct_text.redraw();
instruct_trial.present();