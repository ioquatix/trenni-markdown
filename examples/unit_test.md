	#include <UnitTest/UnitTest.hpp>
	#include <Dream/Events/Loop.hpp>
	#include <Dream/Events/Source.hpp>

# Dream::Events

## Timer Test

### A timer is scheduled and called correctly

	auto event_loop = ref(new Loop);

	int ticks = 0;

	event_loop->schedule_timer(new TimerSource([&](Loop *, TimerSource *, Event){
		event_loop->stop();
	}, 1.0));

	event_loop->schedule_timer(new TimerSource([&](Loop *, TimerSource *, Event){
		ticks += 1;
	}, 0.01, true));

	event_loop->run_forever();

	examiner << "Ticker callback called correctly";
	examiner.expect(ticks) == 100;

### A timer is scheduled and runs for a limited time

	auto event_loop = ref(new Loop);

	int ticks = 0;

	event_loop->schedule_timer(new TimerSource([&](Loop *, TimerSource *, Event){
		ticks += 1;
	}, 0.01, true));

	event_loop->run_until_timeout(0.11);

	examiner << "Ticker callback called correctly within specified timeout";
	examiner.expect(ticks) == 10;
