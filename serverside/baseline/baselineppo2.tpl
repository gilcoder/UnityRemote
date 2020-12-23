def to_image(img):
    imgdata = image_decode(img, #IW, #IH)
    return imgdata

#BEGIN::GENERATED CODE :: DON'T CHANGE
def get_state_from_fields(fields):
    #TPL_RETURN_STATE

class Agent(BasicAgent):
	def __init__(self):
		BasicAgent.__init__(self)

	def reset(self, env):
		env_info = env.remoteenv.step("restart")
		return get_state_from_fields(env_info)

	def act(self, env, action, info=None):
		for _ in range(#SKIP_FRAMES):
			envinfo = env.one_step(action)
			if envinfo['done']:
				break
		state = get_state_from_fields(envinfo)
		return state, envinfo['reward'], envinfo['done'], envinfo

def make_env_def():
    environment_definitions['state_shape'] = #TPL_INPUT_SHAPE
    #DISABLE52environment_definitions['extra_inputs_shape'] = (#ARRAY_SIZE,)
    environment_definitions['action_shape'] = #TPL_OUTPUT_SHAPE
    environment_definitions['actions'] = #TPL_ACTIONS
    environment_definitions['agent'] = Agent
    environment_definitions['input_port'] = #INPUT_PORT
    environment_definitions['output_port'] = #OUTPUT_PORT
    BasicAgent.environment_definitions = environment_definitions

make_env_def()
#END::GENERATED CODE :: DON'T CHANGE

env = make_vec_env('AI4U-v0', verbose=1, n_steps = 128, learning_rate=0.00003, nminibatches=64, noptepochs=10, n_envs=#WORKERS) #Make the environment
model = PPO2(#PPO2POLICY, env, verbose=1, tensorboard_log="#OUTPUT_LOG")
model.learn(total_timesteps=#TIMESTEPS) #Training loop
model.save('#MODELNAME') #Save trained model.
del model # remove to demonstrate saving and loading
model = PPO2.load('#MODELNAME')
# Enjoy test loop with trained agent
obs = env.reset()
while True:
	action, _states = model.predict(obs)
	obs, rewards, dones, info = env.step(action)
	#env.render()
