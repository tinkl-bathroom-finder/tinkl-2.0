import { useSelector } from 'react-redux';
import { Icon } from 'leaflet';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import blueDotIconFile from './blue_dot.png';
import toiletIconFile from './toilet-marker.png';
import { Button } from '@mui/material';
import { TinklRootState } from '../redux/types/TinklRootState';
import { BathroomType } from '../redux/types/BathroomType';

export const LeafletMap = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
    // const bathroomData = useSelector(state => state.bathroomData);
    // const center = user.location.lat && user.location.lng ? [user.location.lat, user.location.lng] : [44.9560534624369, -93.16002444658359];

    const blueDotIcon = new Icon({
        iconUrl: blueDotIconFile,
        iconSize: [25, 25], // size of the icon
        iconAnchor: [5, 5], // point of the icon which will correspond to marker's location
        popupAnchor: [0, -5] // point from which the popup should open relative to the iconAnchor
    });

    const toiletIcon = new Icon({
        iconUrl: toiletIconFile,
        iconSize: [25, 25],
        iconAnchor: [5, 5],
        popupAnchor: [0, -5]
    });


    return (
        <MapContainer center={user.location} zoom={13} style={{ height: "100%", width: "100%" }}>
            <TileLayer
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            />
            <Marker
                position={user.location}
                icon={blueDotIcon}
            >
                {bathroomData.map((item, index) => {
                    const position = [item.latitude, item.longitude];
                    return (
                        <Marker
                            key={index}
                            position={[item.latitude, item.longitude]}
                            icon={toiletIcon}
                            alt={item.name}
                        >
                            <Popup>
                                <p>{item.name}</p>
                                <Button>Flag</Button>
                                <Button>Like</Button>

                            </Popup>
                        </Marker>
                    )
                })
                }
            </Marker>
        </MapContainer>
    );
};
