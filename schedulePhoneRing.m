function schedulePhoneRing( delay )
% schedulePhoneRing( delay )
%
% (Part of the Navigation Task Suite package)
% Schedules an incoming call event <delay> seconds in the future
%
% delay                 desired time (s) in the future to inititate phone
%                       ringing.
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    exp.ringAt = GetSecs() + delay;
    exp.ringScheduled = true;
    logEvent(sprintf('PhoneRingScheduled,%f',GetSecs() - exp.startTime + delay));
end

