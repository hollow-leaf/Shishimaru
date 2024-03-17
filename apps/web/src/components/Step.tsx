import React, { useEffect, useState } from 'react';

// 定义一个类型来表示地理位置坐标
interface Position {
  latitude: number;
  longitude: number;
}

const averageStepLength = 0.762; // 成人平均步长（米）

// Haversine公式函数，添加了类型注释
function calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    console.log(lat1, lon1, lat2, lon2);
  const R = 6371e3; // 地球半径，单位：米
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lon2 - lon1) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  const distance = R * c; // 最终距离，单位：米
  console.log(distance);
  return distance;
}

const StepCounter: React.FC = () => {
  const [distance, setDistance] = useState<number>(0); // 总行走距离（米）
  const [steps, setSteps] = useState<number>(0); // 估算的步数
  useEffect(() => {
    let lastPosition: Position | null = null;

    const watchId = navigator.geolocation.watchPosition(
      (position) => {
        const { latitude, longitude } = position.coords;
        if (lastPosition) {
          const distanceBetween = calculateDistance(lastPosition.latitude, lastPosition.longitude, latitude, longitude);
          setDistance(prevDistance => {
            const newDistance = prevDistance + distanceBetween;
            setSteps(Math.round(newDistance / averageStepLength));
            return newDistance;
          });
        }
        lastPosition = { latitude, longitude };
      },
      (error) => {
        console.error(error);
      },
      { enableHighAccuracy: true, maximumAge: 10000, timeout: 5000 }
    );
    console.log(watchId);
    console.log("distance",distance.toFixed(2));
    console.log("steps",steps);

    return () => navigator.geolocation.clearWatch(watchId);
    //eslint-disable-next-line
  }, []);

  return (
    <div>
      <p>走過距離：{distance.toFixed(2)} 米</p>
      <p>估算步數：{steps}</p>
    </div>
  );
}

export default StepCounter;


