import React from "react";
import { useDispatch } from "react-redux";
import { BathroomType } from "../../../redux/types/BathroomType";
import L from 'leaflet';
import { Popup, useMap } from "react-leaflet";

import { Button } from "@mui/material";

// MUI Icons
import {
  AccessibleForwardOutlined,
  BabyChangingStationOutlined,
  Man4,
  Public,
  ThumbUpOutlined,
  ThumbDownOutlined,
  TransgenderOutlined,
  Close,
} from "@mui/icons-material";

// Components
import { OpenInMapsButton } from './OpenInMapsButton';
import { GetDirectionsButton } from "./GetDirectionsButton";

// Actions
import { toggleDetailsScreen } from "../../../redux/reducers/tinklOptionsReducer";
import { setBathroomID } from "../../../redux/reducers/tinklOptionsReducer";

//Modules
import { stringifyDate } from "../../../modules/stringifyDate";

interface MapInfoWindowProps {
  bathroom: BathroomType;
}

export const MapInfoWindow: React.FC<MapInfoWindowProps> = ({ bathroom }) => {

  const dispatch = useDispatch();
  const map = useMap();
  const handleShowDetails = (bathroom: BathroomType) => {
    console.log('bathroom.id: ', bathroom.id)
    dispatch(setBathroomID(bathroom.id))
    dispatch(toggleDetailsScreen());
  }

  const openMap = (address: string) => {
    const formattedAddress = encodeURIComponent(address);
    const mapURL = `https://www.google.com/maps/search/?api=1&query=${formattedAddress}`;

    window.open(mapURL, '_blank');
  };

  const handleClose = () => {
    map.closePopup();
  };

  return (
    <Popup
      autoPanPaddingTopLeft={[5, 50]}
      closeButton={false}
    >
      <div
        onClick={handleClose}
        style={{ position: 'relative' }}>
        <Close
          style={{
            position: 'absolute',
            top: '-22px',
            right: '-27px',
            background: 'white',
            color: 'black',
            width: '35px',
            height: '35px',
            cursor: 'pointer',
            borderRadius: 18,
            border: '0.01rem solid black',
          }}
        />
      </div>
      <h2>{bathroom.name}</h2>
      <div onClick={() => openMap(bathroom.name + bathroom.street)} style={{
        cursor: 'pointer',
        color: 'blue',
        textDecoration: 'underline',
        marginTop: 5,
      }}>
        <h3>{bathroom.street}</h3>
        <h3>{bathroom.city}, {bathroom.state}</h3>
      </div>
      <div className="stats"
        style={{
          marginTop: 5,
        }}
      >
        <h3 className={bathroom.is_open ? "open" : "closed"}>{bathroom.is_open ? "Open now" : "Closed"}</h3>
      </div>
      <div className="likes">
        <p>
          {bathroom.public ? <Public /> : ""}
          {bathroom.unisex ? <TransgenderOutlined /> : ""}
          {bathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
          {bathroom.accessible ? <AccessibleForwardOutlined /> : ""}
          {bathroom.is_single_stall ? <Man4 /> : ""}</p>
        <p>
          <ThumbUpOutlined />{bathroom.upvotes}
          <ThumbDownOutlined />{bathroom.downvotes}</p>
      </div>
      <p className="updated">  {`Updated ${stringifyDate(bathroom.updated_at)}`}</p>
      <Button size="small" variant="contained" onClick={() => handleShowDetails(bathroom)}>Details</Button>
    </Popup>)
}