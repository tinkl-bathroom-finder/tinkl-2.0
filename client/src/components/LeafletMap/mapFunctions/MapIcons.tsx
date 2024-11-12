import { Icon } from 'leaflet';

import blueDotIconFile from '../../../assets/mapIcons/blue_dot.png'
import toiletIconFile from '../../../assets/mapIcons/toilet-marker.png';

export const blueDotIcon = new Icon({
    iconUrl: blueDotIconFile,
    iconSize: [25, 25], // size of the icon
    iconAnchor: [5, 5], // point of the icon which will correspond to marker's location
    popupAnchor: [0, -5] // point from which the popup should open relative to the iconAnchor
});

export const toiletIcon = new Icon({
    iconUrl: toiletIconFile,
    iconSize: [60, 60],
    iconAnchor: [20, 60],
    popupAnchor: [0, 0],
});

export const toiletIconClosed = new Icon({
    iconUrl: toiletIconFile,
    iconSize: [60, 60],
    iconAnchor: [5, 5],
    popupAnchor: [0, 0],
    className: 'toilet-icon-closed'
});

