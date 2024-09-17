import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";

import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Typography,
  } from "@mui/material";
  import ExpandMore from "@mui/icons-material/ExpandMore";

interface BusinessHoursProps {
    bathroom: BathroomType
}

export const BusinessHours: React.FC<BusinessHoursProps> = ({bathroom}) => {
    console.log('bathroom:', bathroom)
  
    const convertToTwelveHourTime = (time: number | null) => {
      let twelveHourTime = time/100
      let amOrPm = "am" 
      if (time > 1200) {
        twelveHourTime = twelveHourTime - 12
        amOrPm = "pm"
      
      }
      return `${twelveHourTime}${amOrPm}`
    }

    if( bathroom.day_1_open || bathroom.day_2_open || bathroom.day_3_open || bathroom.day_4_open || bathroom.day_5_open ||  bathroom.day_6_open ){
      return (
          <div className="business-hours">
      <Typography>Monday: {bathroom.day_1_open ? convertToTwelveHourTime(bathroom.day_1_open) + '-' + convertToTwelveHourTime(bathroom.day_1_close)  : "Closed"}</Typography>
      <Typography>Tuesday: {bathroom.day_2_open ? convertToTwelveHourTime(bathroom.day_2_open) + '-' + convertToTwelveHourTime(bathroom.day_2_close) : "Closed"}</Typography>
      <Typography>Wednesday: {bathroom.day_3_open ? convertToTwelveHourTime(bathroom.day_3_open ) + '-' + convertToTwelveHourTime(bathroom.day_3_close) : "Closed"}</Typography>
      <Typography>Thursday: {bathroom.day_4_open ? convertToTwelveHourTime(bathroom.day_4_open ) + '-' + convertToTwelveHourTime(bathroom.day_4_close) : "Closed"}</Typography>
      <Typography>Friday: {bathroom.day_5_open ? convertToTwelveHourTime(bathroom.day_5_open ) + '-' + convertToTwelveHourTime(bathroom.day_5_close) : "Closed"}</Typography>
      <Typography>Saturday: {bathroom.day_6_open ? convertToTwelveHourTime(bathroom.day_6_open ) + '-' + convertToTwelveHourTime(bathroom.day_6_close) : "Closed"}</Typography>
      <Typography>Sunday: {bathroom.day_0_open ? convertToTwelveHourTime(bathroom.day_0_open ) + '-' + convertToTwelveHourTime(bathroom.day_0_close) : "Closed"}</Typography>
      </div>)
  }
  }