import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";

import { TinklRootState } from "../redux/types/TinklRootState";
// Components
import { OpenInMapsButton } from "./OpenInMapsButton";
import { GetDirectionsButton } from "./GetDirectionsButton";
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
  Collapse,
  Typography,
  CardActions,
  IconButton,
  CardMedia,
  Grid,
  Tooltip
} from "@mui/material";

// MUI Icons
import { AccessibleForwardOutlined, BabyChangingStationOutlined, Directions, ExpandMore, Man4, MoreVert, NearMeOutlined, Place, QueryBuilder, ThumbUp, ThumbDown, ThumbUpOutlined, ThumbDownOutlined, TransgenderOutlined } from "@mui/icons-material";

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
      <h2 className="likes"><ThumbUp />4
      <ThumbDownOutlined />0</h2>
      <OpenInMapsButton address={selectedBathroom.name + selectedBathroom.street} />
      <GetDirectionsButton address={selectedBathroom.name + selectedBathroom.street} />

      <p>
        {selectedBathroom.unisex ? <TransgenderOutlined /> : ""}
        {selectedBathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
        {selectedBathroom.accessible ? <AccessibleForwardOutlined /> : ""}
        {selectedBathroom.is_single_stall ? <Man4 /> : ""}</p>
      <p><Place />{selectedBathroom.street}, {selectedBathroom.city}, MN</p>
      <Accordion disableGutters
        sx={{ backgroundColor: '#ffe6e8', boxShadow: 'none' }} >
        <AccordionSummary
          expandIcon={<ExpandMore />}
          aria-controls="panel1-content"
          id="panel1-header"
          sx={{ padding: 0, margin: 0 }}
        >
          <QueryBuilder />
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