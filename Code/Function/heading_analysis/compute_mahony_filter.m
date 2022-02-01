function [heading,pitch] = compute_mahony_filter(data_imu,Kp,Ki,srate)

AHRS = MahonyAHRS('SamplePeriod', 1/srate, 'Kp', Kp,'Ki',Ki);

quaternion = zeros(length(data_imu.gyro(:,1)), 4);
data_imu.accel(:,3) = data_imu.accel(:,3)*-1;
for t = 1:length(data_imu.gyro(:,1))
    AHRS.Update(data_imu.gyro(t,:) * (pi/180), data_imu.accel(t,:), data_imu.mag(t,:));	% gyroscope units must be radians
    quaternion(t, :) = AHRS.Quaternion;
end
euler = quatern2euler(quaternConj(quaternion)) * (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees.
heading = euler(:,3)*-1;
pitch = euler(:,1);
end
