import { useEffect, useState } from "react"
import { useDispatch, useSelector } from "react-redux";
import { Routes, Route } from 'react-router-dom';

import axios from "axios";

//Types
import { TinklRootState } from "./redux/types/TinklRootState";
import { BathroomType } from "./redux/types/BathroomType";

//Redux Actions
import { setAllBathroomData } from "./redux/reducers/bathroomReducer";
import { setUser, setUserLocation } from "./redux/reducers/userReducer";
import { toggleAboutScreen, toggleDetailsScreen } from "./redux/reducers/tinklOptionsReducer";

//MUI
import { Dialog, DialogContent, Modal } from "@mui/material";

//Components
import { LoginScreen } from "./components/LoginScreen";
import { ResetPassword } from "./components/ResetPassword";
import { LeafletMap } from "./components/LeafletMap/LeafletMap";
import { ListView } from "./components/ListView/ListView";
import { AboutScreen } from "./components/AboutScreen";
import { BathroomDetails } from "./components/BathroomDetails";
import { SearchBar } from "./components/LeafletMap/SearchBar";
import { ContactUs } from "./components/ContactUs";
import { HeaderNav } from "./components/HeaderNav";

//Modules/Functions
import { getLocalISOTime } from "./modules/getLocalISOTime";

import './App.css';

function App() {

  const user = useSelector((state: TinklRootState) => state.user);
  const options = useSelector((state: TinklRootState) => state.options);
  const [radius, _] = useState(8000);
  const [locationReady, setLocationReady] = useState<boolean>(false);
  const [localISOTime, setLocalISOTime] = useState('');

  const api = import.meta.env.VITE_API_BASE_URL;
  const dispatch = useDispatch();
  // const navigate = useNavigate();


  // Use useEffect to set the local time when the component mounts and once per minute thereafter
  useEffect(() => {
    const currentLocalISOTime = getLocalISOTime();
    setLocalISOTime(currentLocalISOTime);

    const intervalId = setInterval(() => {
      const updatedISOTime = getLocalISOTime();
      setLocalISOTime(updatedISOTime);
    }, 60000);

    return () => clearInterval(intervalId);
  }, []);

  // Checks for logged in user
  useEffect(() => {
    if (!user.username) {
      axios.get(`${api}/user/authenticate/`, { withCredentials: true })
        .then((response) => {
          dispatch(setUser(response.data));
        }).catch((error) => {
          console.log('Error Fetching user from server', error);
        });
    }
  }, []);

  //Gets lat and lng coordinates from user and places it in redux state
  useEffect(() => {
    if (navigator.geolocation) {
      const watcher = navigator.geolocation.watchPosition(
        (position) => {
          dispatch(setUserLocation({ lat: position.coords.latitude, lng: position.coords.longitude }));
          setLocationReady(true);
        },
        (error) => {
          console.error('Error watching position:', error);
        }
      );

      //Return cleans up the watcher on component unmount
      return () => {
        navigator.geolocation.clearWatch(watcher);
      }
    } else {

      //todo - create option to look via zip code
      console.error('Geolocation is not supported by this browser');
    }
  }, []);

  //Makes database call to get bathroom data and puts it into redux
  useEffect(() => {
    if (locationReady) {
      axios.get<BathroomType[]>(`${api}/api/getBathroomsByRadius/?latitude=${user.location.lat}&longitude=${user.location.lng}&radius=${radius}&localISOTime=${localISOTime}`)
        .then(response => {
          dispatch(setAllBathroomData(response.data));
        }).catch(error => {
          console.error('Error retrieving data from db: /getBathroomsByRadius', error);
        })
    } else if (!locationReady) {
      axios.get<BathroomType[]>(`${api}/api/getAllBathrooms/?&localISOTime=${localISOTime}`)
        .then(response => {
          console.log('bathroom response', typeof response.data)
          dispatch(setAllBathroomData(response.data));
        }).catch(error => {
          console.error('Error retrieving data from db: /getAllBathrooms', error);
        })
    }
  }, [locationReady]);

  return (
    <div className="container">

      {/* Use Routes wrapper instead of individual Route elements */}
      <Routes>

        <Route path="/" element={<>
          <HeaderNav />
          <div className='map-container'>
            <SearchBar />
            <LeafletMap />
          </div></>
        } />

        <Route path="/listview" element={<>
          <HeaderNav />
          <div className="map-container">
            <ListView />
          </div></>
        } />

        <Route path="/contact" element={<>
          <HeaderNav />
          <div className="contactContainer">
            <ContactUs />
          </div></>

        } />

        <Route path="/reset-password" element={<ResetPassword />} />

        <Route path="/login" element={<LoginScreen />} />

      </Routes>

      {/* Modals */}
      {options.showAbout && (
        <Dialog
          open={options.showAbout}
          onClose={() => dispatch(toggleAboutScreen())}
          PaperProps={{
            sx: {
              backgroundColor: 'rgba(0, 0, 0, 0)',
              boxShadow: 'none',
            },
          }}
        >
          <DialogContent>
            <AboutScreen />
          </DialogContent>
        </Dialog>
      )}

      {options.showDetails && (
        <Modal open={options.showDetails} onClose={() => dispatch(toggleDetailsScreen())}>
          <BathroomDetails />
        </Modal>
      )}
    </div>
  );
}

export default App;
