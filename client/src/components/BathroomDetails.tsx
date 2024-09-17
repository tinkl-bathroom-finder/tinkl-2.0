import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";
import { OpenInMapsButton } from "./OpenInMapsButton";
import { IPeedHereButton } from "./IPeedHereButton";
import { BusinessHours } from "./BusinessHours";



// MUI imports
import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Box,
  Button,
  Card,
  CardContent,
  CardHeader,
  Typography,
  CardActions,
  IconButton,
  CardMedia,
  Grid,
  Tooltip
} from "@mui/material";
import Collapse from "@mui/material/Collapse";


import ExpandMore from "@mui/icons-material/ExpandMore";
import PlaceIcon from '@mui/icons-material/Place';
import QueryBuilderIcon from '@mui/icons-material/QueryBuilder';
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

import { TinklRootState } from "../redux/types/TinklRootState";

interface BathroomDetailsProps {
  bathroom: BathroomType
}

export const BathroomDetails: React.FC<BathroomDetailsProps> = ({ bathroom }) => {
  const options = useSelector((state: TinklRootState) => state.options);
  const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
  const selectedBathroom = bathroomData.filter(function (br) { return br.id === options.selectedBathroomID })[0]
  console.log("selectedBathroom", selectedBathroom)

  // formats inserted_at timestamp as readable string
  const stringifyDate = (timestamp) => {
    const date = new Date(timestamp);
    const options = { year: "numeric", month: "short", day: "numeric" };
    const stringifiedDate = date.toLocaleDateString("en-us", options);
    return stringifiedDate;
  };
  return (
    <div className="detailsContainer">
      <h1>{selectedBathroom.name}</h1>

      <h3><PlaceIcon />{selectedBathroom.street}, {selectedBathroom.city}, MN</h3>
      <h3></h3>
      <OpenInMapsButton address={selectedBathroom.name + selectedBathroom.street} />
      <p>
        {selectedBathroom.unisex ? <TransgenderOutlinedIcon /> : ""}
        {selectedBathroom.changing_table ? <BabyChangingStationOutlinedIcon /> : ""}
        {selectedBathroom.accessible ? <AccessibleForwardOutlinedIcon /> : ""}
        {selectedBathroom.is_single_stall ? <Man4Icon /> : ""}</p>
   
      <Accordion disableGutters
          sx={{backgroundColor: '#ffe6e8', boxShadow: 'none'}} >
        <AccordionSummary
          expandIcon={<ExpandMore />}
          aria-controls="panel1-content"
          id="panel1-header"
          sx={{padding: 0, margin: 0}}
        >
          <QueryBuilderIcon />
               <p className={selectedBathroom.is_open ? "open" : "closed"}>
        {selectedBathroom.is_open ? "Open now" : "Closed"}
        </p>
        </AccordionSummary>
        <BusinessHours bathroom={selectedBathroom} />
      </Accordion>


      <p>  {`Updated ${stringifyDate(selectedBathroom.updated_at)}`}</p>

      <IPeedHereButton id={selectedBathroom.id} />
    </div>
  )
}