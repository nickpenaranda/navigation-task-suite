function schedulePhoneRing( delay )
    global exp;
    exp.ringAt = GetSecs() + delay;
    exp.ringScheduled = true;
    logEvent(sprintf('PhoneRingScheduled,%f',GetSecs() - exp.startTime + delay));
end

