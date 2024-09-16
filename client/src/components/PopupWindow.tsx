import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";
import { Popup } from "react-leaflet";

// Types
import { TinklRootState } from "../redux/types/TinklRootState";

import {
    Avatar,
    Box,
    Button,
    Card,
    CardContent,
    CardHeader,
    Typography,
    CardActions,
    IconButton,
    Grid,
    Paper,
  } from "@mui/material";

import DirectionsIcon from "@mui/icons-material/Directions";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import MoreVertIcon from "@mui/icons-material/MoreVert";
import ThumbUpOutlinedIcon from "@mui/icons-material/ThumbUpOutlined";
import ThumbDownOutlinedIcon from "@mui/icons-material/ThumbDownOutlined";
import BabyChangingStationOutlinedIcon from "@mui/icons-material/BabyChangingStationOutlined";
import AccessibleForwardOutlinedIcon from "@mui/icons-material/AccessibleForwardOutlined";
import TransgenderOutlinedIcon from "@mui/icons-material/TransgenderOutlined";
import NearMeOutlinedIcon from "@mui/icons-material/NearMeOutlined";
import Man4Icon from "@mui/icons-material/Man4";

// Components
import { OpenInMapsButton } from './OpenInMapsButton';

// Actions
import { toggleDetailsScreen } from "../redux/reducers/tinklOptionsReducer";

interface PopupWindowProps {
    bathroom: BathroomType
}

interface TimestampProps {
    timestamp: TimeType
}

export const PopupWindow: React.FC<PopupWindowProps> = ({bathroom}) => {

    const tinklOptions = useSelector((state: TinklRootState) => state.options);
    const dispatch = useDispatch();

  // formats inserted_at timestamp as readable string
  const stringifyDate = (timestamp) => {
    const date = new Date(timestamp);
    const options = { year: "numeric", month: "short", day: "numeric" };
    const stringifiedDate = date.toLocaleDateString("en-us", options);
    return stringifiedDate;
  };

  const handleShowDetails = () => {
    dispatch(toggleDetailsScreen());
}

    return(
        <Popup>
        <h1>{bathroom.name}</h1>
        <h2>{bathroom.street}</h2>
        <h2>{bathroom.city}, MN</h2><p>
            {bathroom.unisex ? <TransgenderOutlinedIcon /> : ""}
            {bathroom.changing_table ? <BabyChangingStationOutlinedIcon /> : ""}
            {bathroom.accessible ? <AccessibleForwardOutlinedIcon /> : ""}
            {bathroom.is_single_stall ? <Man4Icon /> : ""}</p>
            <h3 className={bathroom.is_open ? "open" : "closed"}>{bathroom.is_open ? "Open now" : "Closed"}</h3>
        <h3>{bathroom.day_5_open} - {bathroom.day_5_close}</h3>
        <p>  {`Updated ${stringifyDate(bathroom.updated_at)}`}</p>
        <Button onClick={handleShowDetails}>Details</Button>
        <OpenInMapsButton address={bathroom.street}/>
        <Button>Like</Button>
    </Popup>)
}